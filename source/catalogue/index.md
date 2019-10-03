# APIs in the UK government

This API catalogue is for central government and local government APIs.

If you're working on an API that publishes open data or connects government with other organisations, industry or consumers, we’d like to invite you to publish details of it in this catalogue. You can publish details of your API by submitting a [GitHub Issue](https://github.com/alphagov/api-catalogue/issues).

Collecting a list of government APIs will help us understand:

* what APIs are published
* where API development is taking place
* whether APIs are suitable for reuse

If you have any questions, please contact: <api-standards-request@digital.cabinet-office.gov.uk>

## Government Digital Service

**API name:**
GOV.UK Notify API

**API links:**
 - [Base URL](https://api.notifications.service.gov.uk)
 - [Documentation URL](https://www.notifications.service.gov.uk/documentation)

**API description:**

GOV.UK Notify allows government departments to send emails, text messages and letters to their users. The API contains:

- the public-facing REST API for GOV.UK Notify, which teams can integrate with using our clients
- an internal-only REST API built using Flask to manage services, users, templates, etc (this is what the admin app talks to)
- asynchronous workers built using Celery to put things on queues and read them off to be processed, sent to providers, updated, etc
