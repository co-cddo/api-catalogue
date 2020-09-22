---
title: Personal Demographics Service - FHIR API
weight: 10
---

# NHS: Personal Demographics Service - FHIR API

## Documentation URL:
 - [https://portal.developer.nhs.uk/docs/personal-demographics-int/1/overview](https://portal.developer.nhs.uk/docs/personal-demographics-int/1/overview)

## Description:
Overview-n-nUse this API to access the Personal Demographics Service (PDS) - the national electronic database of NHS patient details such as name, address, date of birth, related people and NHS Number.-n-nYou can:-n-n    search for patients-n    get patient details-n    update patient details-n-nYou cannot currently use this API to:-n-n    check that you have the right NHS Number for a patient (but you can achieve this indirectly using search for patient or get patient details)-n    create a new record for a birth-n    receive birth notifications-n    create a record for a new patient-n    register a new patient at a GP Practice - instead, use NHAIS GP Links API-n-nYou can read and update the following data:-n-n    NHS Number (read only)-n    name-n    gender-n    addresses and contact details-n    birth information-n    death information-n    registered GP-n    nominated pharmacy-n    dispensing doctor pharmacy-n    medical appliance supplier pharmacy-n    related people, such as next of kin (read only - update coming soon)-n-nCurrently, this API can only be accessed by healthcare professionals, authenticated with an NHS smartcard or equivalent. Unauthenticated access and citizen access are on the roadmap.

