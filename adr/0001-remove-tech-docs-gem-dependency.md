---
creation_date: 2020-11-05
decision_date: 2020-11-09
status: approved
---

# Remove the Tech Docs Gem Dependency

## Context

The main data source of the API catalogue website was originally a collection of
markdown files. The build process uses the Middleman static site generator
configured by the [Tech Docs Gem](https://github.com/alphagov/tech-docs-gem)
('TDG').

The TDG provides additional functionality including search, sidebar
navigation ('Table of Contents'), the layout, and styling.

The TDG is not necessarily a good fit for the API catalogue because the project
isn't purely documentation, and our data source is now a CSV.

In particular it is difficult to override templates inherited from the gem, to
adjust the layout on a particular page or add page-specific JavaScript for
example.

Using TDG to render the Table of Contents is slow for our site because
by design every page is re-rendered multiple times to pull out the headings
(adding over a minute to build times).

The TDG also requires specific dependency versions. These version
restrictions prevent us being in control of version upgrades which are necessary
to remain on support versions and receive security patches.

## Decision

Remove the TDG as a dependency by vendoring the code relevant to
the API catalogue directly into the project itself.

## Consequences

The API catalogue project can be customized more easily, and the team has more
control over dependency management.

Downsides include the API catalogue having more code which needs to be
maintained. Also we no longer automatically benefit from any future fixes or
additional features added to the TDG without manually copying them across.
