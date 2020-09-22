---
title: Electronic Prescription Service - FHIR API
weight: 10
---

# NHS: Electronic Prescription Service - FHIR API

## Documentation URL:
 - [https://portal.developer.nhs.uk/docs/electronic-prescription-service-api-int/1/overview](https://portal.developer.nhs.uk/docs/electronic-prescription-service-api-int/1/overview)

## Description:
Use this API to access the Electronic Prescription Service (EPS) <https://digital.nhs.uk/services/electronic-prescription-service> - the national service used to send electronic prescriptions from GP surgeries to pharmacies.-n-nYou can:-n-n    prepare a secondary care (outpatient) prescription for signing-n    create a secondary care (outpatient) prescription-n    evaluate prescription signing client implementations-n-nYou cannot currently use this API to:-n-n    prepare a primary care prescription for signing-n    create a primary care prescription-n    prepare a secondary care (other than outpatient) prescription for signing-n    create a secondary care (other than outpatient) prescription-n    prepare a tertiary care prescription for signing-n    create a tertiary care prescription-n    cancel a prescription-n    check the status of a prescription-n    release a prescription for dispensing-n    claim for a dispensed prescription-n    Track prescriptions or check a prescriptions status-n-nCurrently, this API can only be accessed by healthcare professionals, authenticated with an NHS smartcard or equivalent.-n-nPlease use the following values for courseOfTherapyType depending on the submitted prescription type:-n-n    acute => acute-n    repeat => continuous-n    repeat-dispensing => continuous-repeat-dispensing-n

