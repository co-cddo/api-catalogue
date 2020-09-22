---
title: Messaging Exchange for Social care and Health (MESH)
weight: 10
---

# NHS: Messaging Exchange for Social care and Health (MESH)

## Documentation URL:
 - [https://meshapi.docs.apiary.io/#](https://meshapi.docs.apiary.io/#)

## Description:
The Message Exchange for Social care and Health (MESH) component of the Spine allows messages and files to be delivered to registered recipients via a java client. Users register for a mailbox and install the client. The MESH client manages the sending of messages which users (typically user systems) have placed in an outbox directory on their machine.-n-nIt similarly manages the downloading of messages and files which other users have placed in the user's virtual inbox on the Spine. The MESH server has been designed with an underlying HTTP based protocol. This protocol is capable of being used directly where user systems wish to bypass the MESH client or where they want to construct their own clients. Thus the MESH service will become a direct 'store and retrieve' messaging mechanism between endpoints as a new asynchronous pattern for Spine consumers. MESH uses a RESTful paradigm and thus messages which are send via mesh are POSTed to a MESH virtual outbox and recipients retrieve messages through a GET to their virtual inbox. The following document summarises the MESH HTTP API which may be used by clients directly or over which other SOAP or other APIs may be overlaid.-n-nPlease note that the Production Server listed in the Console of this Apiary page refers to NHS Digital's Solution Assurance Integration test environment and not Live. Therefore, certificates, mailbox and mailbox passwords need to be created in order to test using this Apiary webpage-n-nPlease contact the Solutions Assurance helpdesk to request these.

