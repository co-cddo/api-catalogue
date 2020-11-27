---
creation_date: 2020-11-27
decision_date: 2020-11-27
status: approved
---

# Reduce Internet Explorer 6, 7, 8 support

## Context

The API catalogue has been using an obsolete version of jQuery (1.x). This
version has reported security vulnerabilities which will not be patched:

- https://npmjs.com/advisories/328
- https://npmjs.com/advisories/796
- https://npmjs.com/advisories/1518

## Decision

Upgrade to jQuery 3.x (the current major version at the time of writing). This
removes explicit support for IE 6, 7, 8.

This decision is in line with the broader GDS stance to change [testing
requirements for older version of Internet Explorer][gds-ie-testing]

## Consequences

Visitors using obsolete browsers may encounter degraded or no JavaScript
functionality. Navigation between pages with standard hyperlinks will be
unaffected.

[gds-ie-testing]: https://technology.blog.gov.uk/2018/06/26/changing-our-testing-requirements-for-internet-explorer-8-9-and-10/
