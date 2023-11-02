
<p align="center">
<img src="https://github.com/paperless-ngx/paperless-ngx/raw/main/resources/logo/web/png/Black%20logo%20-%20no%20background.png#gh-light-mode-only" width="50%" />
</p>

<!-- omit in toc -->

# Paperless-ngx

Paperless-ngx is a document management system that transforms your physical documents into a searchable online archive so you can keep, well, _less paper_.

Paperless-ngx forked from [paperless-ng](https://github.com/jonaswinkler/paperless-ng) to continue the great work and distribute responsibility of supporting and advancing the project among a team of people. [Consider joining us!](#community-support) Discussion of this transition can be found in issues
[#1599](https://github.com/jonaswinkler/paperless-ng/issues/1599) and [#1632](https://github.com/jonaswinkler/paperless-ng/issues/1632).

A demo is available at [demo.paperless-ngx.com](https://demo.paperless-ngx.com) using login `demo` / `demo`. _Note: demo content is reset frequently and confidential information should not be uploaded._

- [Features](#features)
- [Getting started](#getting-started)
- [Contributing](#contributing)
  - [Community Support](#community-support)
  - [Translation](#translation)
  - [Feature Requests](#feature-requests)
  - [Bugs](#bugs)
- [Affiliated Projects](#affiliated-projects)
- [Important Note](#important-note)

# Features

![Dashboard](https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/main/docs/assets/screenshots/documents-smallcards.png#gh-light-mode-only)
![Dashboard](https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/main/docs/assets/screenshots/documents-smallcards-dark.png#gh-dark-mode-only)

- Organize and index your scanned documents with tags, correspondents, types, and more.
- Performs OCR on your documents, adds selectable text to image only documents and adds tags, correspondents and document types to your documents.
- Supports PDF documents, images, plain text files, and Office documents (Word, Excel, Powerpoint, and LibreOffice equivalents).
  - Office document support is optional and provided by Apache Tika (see [configuration](https://docs.paperless-ngx.com/configuration/#tika))
- Paperless stores your documents plain on disk. Filenames and folders are managed by paperless and their format can be configured freely.
- Single page application front end.
  - Includes a dashboard that shows basic statistics and has document upload.
  - Filtering by tags, correspondents, types, and more.
  - Customizable views can be saved and displayed on the dashboard.
- Full text search helps you find what you need.
  - Auto completion suggests relevant words from your documents.
  - Results are sorted by relevance to your search query.
  - Highlighting shows you which parts of the document matched the query.
  - Searching for similar documents ("More like this")
- Email processing: Paperless adds documents from your email accounts.
  - Configure multiple accounts and filters for each account.
  - When adding documents from mail, paperless can move these mail to a new folder, mark them as read, flag them as important or delete them.
- Machine learning powered document matching.
  - Paperless-ngx learns from your documents and will be able to automatically assign tags, correspondents and types to documents once you've stored a few documents in paperless.
- Optimized for multi core systems: Paperless-ngx consumes multiple documents in parallel.
- The integrated sanity checker makes sure that your document archive is in good health.
- [More screenshots are available in the documentation](https://docs.paperless-ngx.com/#screenshots).

