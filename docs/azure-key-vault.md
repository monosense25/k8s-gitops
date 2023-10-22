# Azure KeyVault + External Secrets

**Original author :** [Gustavo Carvalho](https://blog.container-solutions.com/tutorial-external-secrets-with-azure-keyvault)

### Requirements
- [K8S Cluster](https://k8s.io).
- [external-secrets](https://external-secrets.io/latest/).
- [azure-cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt).

## Introduction

![high-level](https://raw.githubusercontent.com/external-secrets/external-secrets/main/docs/pictures/diagrams-high-level-simple.png)

_image copyright of : [External-Secrets](https://external-secrets.io/)_
 
**External Secrets Operator** is a Kubernetes operator that integrates external secret management systems like [AWS SecretsManager](https://aws.amazon.com/secrets-manager/), [HashiCorpVault](https://www.vaultproject.io/), [Google SecretsManager](https://cloud.google.com/secret-manager), [Azure KeyVault](https://azure.microsoft.com/en-us/services/key-vault/), [IBM Cloud Secrets Manager](https://www.ibm.com/cloud/secrets-manager), [CyberArk Conjur](https://www.conjur.org) and many more. The operator reads information from external APIs and automatically injects the values into a [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/).

## Configuration
External Secrets supports the configuration of several authentication methods for the Azure KeyVault provider. In this guide we are using authentication through Client ID and Secret, as this doesn’t need any other Azure Resources. We are going to go through the following steps:

1. Set up Azure KeyVault
2. Configure External-Secrets

### Set up Azure KeyVault
The following steps are all going to be used with Azure CLI. The first thing we should do is to set up our KeyVault instance:

```bash
TENANT_ID=$(az account show --query tenantId | tr -d \")
RESOURCE_GROUP="MyKeyVaultResourceGroup"
LOCATION="westus"
az group create --location $LOCATION --name $RESOURCE_GROUP
VAULT_NAME="eso-vault-example"
az keyvault create --name $VAULT_NAME --resource-group $RESOURCE_GROUP
```

After that, we can create a secret inside KeyVault:

```bash
SECRET_NAME="example-externalsecret-key"
SECRET_VAlUE="This is our secret now"
az keyvault secret set --name $SECRET_NAME --vault-name $VAULT_NAME --value "$SECRET_VAlUE"
```

The next step is to create an application that External Secrets will use to access the KeyVault instance. We also create a secret with the application credentials:

```bash
APP_NAME="ExtSectret Query App"
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId | tr -d \")
SERVICE_PRINCIPAL=$(az ad sp create --id $APP_ID --query objectId | tr -d \")
az ad app permission add --id $APP_ID --api-permissions f53da476-18e3-4152-8e01-aec403e6edc0=Scope --api cfa8b339-82a2-471a-a3c9-0fc0be7a4093
APP_PASSWORD="ThisisMyStrongPassword"
az ad app credential reset --id $APP_ID --password "$APP_PASSWORD"

az keyvault set-policy --name $VAULT_NAME --object-id $SERVICE_PRINCIPAL --secret-permissions get

kubectl create secret generic azure-secret-sp --from-literal=ClientID=$APP_ID --from-literal=ClientSecret=$APP_PASSWORD
```

### Configuring External Secrets
After setting up Azure KeyVault, the next step is to create a SecretStore and an ExternalSecrets to fetch example-external secret-key object that we’ve created earlier:

```bash
cat << EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1alpha1
kind: SecretStore
metadata:
  name: azure-backend
spec:
  provider:
    azurekv:
      tenantId: $TENANT_ID
      vaultUrl: "https://$VAULT_NAME.vault.azure.net"
      authSecretRef:
        clientId:
          name: azure-secret-sp
          key: ClientID
        clientSecret:
          name: azure-secret-sp
          key: ClientSecret
---
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
  name: azure-example
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: SecretStore
    name: azure-backend
  target:
    name: azure-secret
  data:
  - secretKey: foobar
    remoteRef:
      key: example-externalsecret-key
EOF
```
And that’s it! We can check that our Secret has been created in Kubernetes:

```bash
kubectl get secret azure-secret -o jsonpath='{.data.foobar}' | base64 -d
This is our secret now

```

We can also check ExternalSecrets status information:

```bash
kubectl get es
NAME            STORE           REFRESH INTERVAL   STATUS
azure-example   azure-backend   1h                 SecretSynced
```


## Deploying an Admission Controller to limit ExternalSecrets access
As you may have noticed at the time of writing Azure Key Vault does not support granular permissions for secrets reading. For production environments, this behaviour is often unacceptable, especially in organisations that have multiple teams and solid governance in place. One way to mitigate this is by using different Azure KeyVault instances for each team. To do this, we just have to follow the same procedure, and create a new SecretStore pointing to the newly provided credentials.

However, depending on the topology a given corporation has, this solution requires us to create SecretStores and Secrets credentials for each namespace of each team, which has two problems: it becomes impracticable at any sort of scale, and it can also bring security issues such as exposing the application credentials to developers. A better workaround is to create or use a custom Admission Controller to verify any ExternalSecrets manifest creation, and prevent the use of specific keys that are not allowed in that specific namespace.

For this guide, we are going to use OPA Gatekeeper as our Admission Controller, but similar behaviour can also be achieved with Kyverno. We are going to install Gatekeeper and configure it to verify if the namespace of the ExternalSecret allows the remote references the ExternalSecret wants to access.  The first step is to install Gatekeeper in our cluster, following their installation guide:

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.7/deploy/gatekeeper.yaml
```

The next step is to configure Gatekeeper to keep track of Namespace resources. This is going to be used as a way to read the regex annotation we are going to create:

```bash
cat << EOF | kubectl apply -f -
apiVersion: config.gatekeeper.sh/v1alpha1
kind: Config
metadata:
  name: config
  namespace: "gatekeeper-system"
spec:
  sync:
    syncOnly:
      - group: ""
        version: "v1"
        kind: "Namespace"
EOF
```

Then, we create a Constraint Template to block any upcoming requests that don’t match a given regex provided by the annotation:

```bash
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: esovalidatesecretreference
  annotations:
    description: >-
      Verifies that all secret references match a regex on the CSS.
spec:
  crd:
    spec:
      names:
        kind: EsoValidateSecretReference
      validation:
        openAPIV3Schema:
          type: object
          properties:
            annotation:
              type: string
              description: >-
                Annotation to verify regex to be applied


  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package esovalidatesecretreference

        violation[{"msg": msg}] {
          namespace := input.review.object.metadata.namespace
          target := data.inventory.cluster["v1"]["Namespace"][namespace]
          not target.metadata.annotations[input.parameters.annotation]
          msg := sprintf("Namespace %v not allowed to receive secrets (missing annotation %v)",[namespace, input.parameters.annotation])
        }
        
        violation[{"msg": msg}] {
          namespace := input.review.object.metadata.namespace
          secretrefs := input.review.object.spec.dataFrom[_].key
          target := data.inventory.cluster["v1"]["Namespace"][namespace]
          regex := target.metadata.annotations[input.parameters.annotation]
          not re_match(regex, secretrefs)
          msg := sprintf("Data From key %v not allowed in Namespace %v",[secretrefs, namespace])
        }
        violation[{"msg": msg}] {
          namespace := input.review.object.metadata.namespace
          secretrefs := input.review.object.spec.data[_].remoteRef.key
          target := data.inventory.cluster["v1"]["Namespace"][namespace]
          regex := target.metadata.annotations[input.parameters.annotation]
          not re_match(regex, secretrefs)
          msg := sprintf("Data key remote ref %v not allowed in namespace %v",[secretrefs, namespace])
        }
```

This constraint template contains three violation clauses.

The first one checks that the namespace contains the appropriate annotation for it (and fails if it doesn’t), the second one prevents any keys from dataFrom being different than the provided regular expression, whilst the third one prevents any keys from data.remoteRef being different than the provided regular expression.

After creating our constraint template, the next step is to define a constraint that uses it:

```bash
cat << EOF | kubectl apply -f -
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: EsoValidateSecretReference
metadata:
  name: validate-css-with-regex-on-path
spec:
  match:
    kinds:
      - apiGroups: ["external-secrets.io"]
        kinds: ["ExternalSecret"]
  parameters:
    annotation: "external-secrets.io/match-regex"
EOF
```

With this constraint, for an ExternalSecret to be created in a given namespace, three things must happen:

1. That namespace must contain the annotation "external-secrets.io/match-regex"
2. All of its data.remoteRef.key values must match the specified regular expression.
3. All of its dataFrom.keys values must match the specified regular expression.

We can test it by annotating namespace default with the following regular expression, which allows any secret keys starting with key-team-1:

```bash
kubectl annotate ns default external-secrets.io/match-regex="^key-team-1-.*"
```

Now, let’s try to create the same ExternalSecrets we had before:

```bash
cat <<EOF | kubectl apply -f -                                                      
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
  name: opa-example
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: SecretStore
    name: azure-backend
  target:
    name: azure-secret
  data:
  - secretKey: foobar
    remoteRef:
      key: example-externalsecret-key
EOF

Error from server ([validate-css-with-regex-on-path] Data key remote ref example-externalsecret-key not allowed in namespace default): error when creating "STDIN": admission webhook "validation.gatekeeper.sh" denied the request: [validate-css-with-regex-on-path] Data key remote ref example-externalsecret-key not allowed in namespace default
```

As we can see, this manifest is no longer authorised to be used because it references an unauthorised remote reference key, even though we’ve just changed the name from our example!

Let’s add a new secret to Azure KeyVault and change the ExternalSecrets definition:

```bash
az keyvault secret set --name "key-team-1-database" --vault-name $VAULT_NAME --value "database-dns"

cat << EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
  name: opa-example
spec:
  refreshInterval: "15s"
  secretStoreRef:
    name: azure-backend
    kind: SecretStore
  target:
    name: example-sync
  data:
  - secretKey: foobar
    remoteRef:
      key: key-team-1-database
EOF

externalsecret.external-secrets.io/opa-example created
```

That’s it! Once there is an Admission Controller installed, it is possible to add Attribute Based Access Control to ExternalSecrets objects. Applying these configurations allows us to enable granular control on our secrets without adding a larger overload on the cluster administration team.

If you need a special configuration on your specific setup, It is also possible to configure which SecretStores / ClusterSecretStores an ExternalSecrets can reference to. Please refer to the Gatekeeper policy library for examples on how to do so.


### :book: Credits

Please visits original author : [Gustavo Carvalho](https://blog.container-solutions.com/tutorial-external-secrets-with-azure-keyvault)


### :books: Other Resources

- Artem Lajko [Unlocking the Potential: External-Secrets and Azure Kubernetes Service Integration](https://blog.devops.dev/unlocking-the-potential-external-secrets-and-azure-kubernetes-service-integration-f562c58d7472)
- Microsoft [Creating Azure Key-Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/quick-create-portal)
- [External-Secrets](https://external-secrets.io/latest/)
