---
title: Organisation Data Service - FHIR_ORD API
weight: 10
---

# NHS: Organisation Data Service - FHIR_ORD API

## Documentation URL:
 - [https://digital.nhs.uk/services/organisation-data-service/guidance-for-developers](https://digital.nhs.uk/services/organisation-data-service/guidance-for-developers)

## Description:
Hosting Organisation Reference Data via an API is a step increase in service for all ORD consumers. Consumers are able to access the data at their convenience rather than being tied in to fixed release schedules.  The data hosted within the service is updated daily directly from the ODS team and is available to all users and is accessible to any browser or REST client via the internet. Users can baseline using XML products and read updates direct from the ORD API or use the service for Ad hoc queries using the search facility documented within these pages.-n-nThe API can be called using a REST client such as Postman or by building a custom REST client.-n-nPlease note that the IP address for the API is dynamic and it is advised that firewalls are configured using the FQDN (Fully Qualified Domain Name) of the service -  directory.spineservices.nhs.uk.-n-nThis guide details the ODS ORD API, which is designed to be compatible with the Organisation Reference Data information standard (DCB0090). This API contains the full record from ODS.-n-nNote that the ORD API returns data in JSON format by default. Users requiring XML need to append the HTTP parameter '_format=xml' to retrieve data formatted as XML.

