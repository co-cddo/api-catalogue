# APIs in the UK government

This API catalogue is for central government and local government APIs.

If you're working on an API that publishes open data or connects government with other organisations, industry or consumers, we’d like to invite you to publish details of it in this catalogue. You can publish details of your API by submitting a [GitHub Issue](https://github.com/alphagov/api-catalogue/issues).

Collecting a list of government APIs will help us understand:

* what APIs are published
* where API development is taking place
* whether APIs are suitable for reuse

If you have any questions, please contact: <api-standards-request@digital.cabinet-office.gov.uk>

## Government Digital Service

### GOV.UK Notify API

**API Base URL links:**

 - [Base URL](https://api.notifications.service.gov.uk)

**API Docs URL links:**

 - [Documentation URL](https://www.notifications.service.gov.uk/documentation)

**API Description:**

GOV.UK Notify allows government departments to send emails, text messages and letters to their users. The API contains:

- the public-facing REST API for GOV.UK Notify, which teams can integrate with using our clients
- an internal-only REST API built using Flask to manage services, users, templates, etc (this is what the admin app talks to)
- asynchronous workers built using Celery to put things on queues and read them off to be processed, sent to providers, updated, etc

### GOV.UK Platform as a Service (PaaS) API

**API Base URL links:**

- [AWS Dublin Base URL](https://api.cloud.service.gov.uk)
- [AWS Dublin Base URL v2](https://api.cloud.service.gov.uk/v2)
- [AWS Dublin Base URL v3](https://api.cloud.service.gov.uk/v3)
- [AWS London Base URL](https://api.london.cloud.service.gov.uk)
- [AWS London Base URL v2](https://api.london.cloud.service.gov.uk/v2)
- [AWS London Base URL v3](https://api.london.cloud.service.gov.uk/v3)

**API Docs URL links:**

- [Documentation for v2](https://apidocs.cloudfoundry.org/12.0.0/)
- [Documentation for v3](http://v3-apidocs.cloudfoundry.org/version/3.74.0/)

**API Description:**

[GOV.UK PaaS](https://www.cloud.service.gov.uk/) allows government departments to host web facing services in the AWS cloud in Dublin and London regions.

[GOV.UK PaaS](https://www.cloud.service.gov.uk/) is built on the Open Source [Cloud Foundry](https://www.cloudfoundry.org/) platform.

There are two major versions of the API, v2 and v3.

The API provides a comprehensive set of resources to manage the state of your Cloud Foundry Organisation, Spaces, Services and Applications.

[GOV.UK PaaS Technical Documentation for Users](https://docs.cloud.service.gov.uk/)

The  API  handles all requests from the [Cloud Foundry Command Line Interface (CLI)](https://docs.cloudfoundry.org/cf-cli/) which is the primary user interface for users of the platform.
