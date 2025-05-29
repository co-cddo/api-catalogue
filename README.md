# APIs in the UK government

This API catalogue is for central government and local government APIs.

If you are working on an API that publishes open data or connects government with other organisations, industry or consumers, we’d like to invite you to publish details of it in this catalogue. You can publish details of your API by submitting a [GitHub Issue](https://github.com/co-cddo/api-catalogue/issues).

Collecting a list of government APIs will help us understand:

* what APIs are published
* where API development is taking place
* whether APIs are suitable for reuse

If you have any questions, please contact:
api-catalogue@digital.cabinet-office.gov.uk

## Working on the API Catalogue

- [Getting started](./docs/getting_started.md)
- [Deployment workflow](./docs/deployment.md)

## Licence

Unless stated otherwise, the codebase is released under the [MIT licence](./LICENSE).

The data is [© Crown
copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/copyright-and-re-use/crown-copyright/)
and available under the terms of the [Open Government
3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)
licence.

## Data sources

Note that data used to generate the catalogue is mainly held in a local CSV file: data/catalogue.csv.

However, additional data is pulled from https://github.com/co-cddo/api-catalogue-data-source as JSON. For convenience, this additional
data has been extracted into a local CSV file data/catalogue-from-json-source.csv to make it easier to compare or combine with the data
in catalogue.csv.
