---
title: GOV.UK Notify
weight: 10
---

# GDS: GOV.UK Notify

## Endpoint URL:
 - [https://api.notifications.service.gov.uk/](https://api.notifications.service.gov.uk/)

## Documentation URL:
 - [https://www.notifications.service.gov.uk/documentation](https://www.notifications.service.gov.uk/documentation)

## Description:
GOV.UK Notify allows government departments to send emails, text messages and letters to their users. The API contains: - the public-facing REST API for GOV.UK Notify, which teams can integrate with using our clients - an internal-only REST API built using Flask to manage services, users, templates, etc (this is what the admin app talks to) - asynchronous workers built using Celery to put things on queues and read them off to be processed, sent to providers, updated, etc

