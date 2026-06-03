# Submitting a bulk update

This page is for anyone who needs to add or change **more than one API at a
time** in the catalogue. For a single API you can open a
[GitHub Issue](https://github.com/co-cddo/api-catalogue/issues) instead.

The catalogue is generated from two CSV files. To publish your changes, edit
those files and open a pull request — once merged, the site rebuilds and
deploys automatically.

## Which files to edit

| File | What it contains | When to edit |
| --- | --- | --- |
| `data/catalogue.csv` | One row per API | Always — this is where APIs live |
| `data/organisation.csv` | One row per department / publishing organisation | Only if your APIs belong to an organisation that is not already listed |

You do **not** need to edit anything under `lib/`, `source/`, or `config.rb`.

## File formats

### `data/catalogue.csv`

Header row (camelCase, do not change):

```
dateAdded,dateUpdated,url,name,description,documentation,license,maintainer,areaServed,startDate,endDate,provider
```

Notes for each column:

- `dateAdded`, `dateUpdated`, `startDate`, `endDate` — ISO format `YYYY-MM-DD`. `dateUpdated` should be today's date. `startDate` and `endDate` may be left blank.
- `url` — the live base URL of the API.
- `name` — human-readable name.
- `description` — free text. If it spans multiple lines or contains commas, wrap the whole field in double quotes and use `\n` for line breaks (see existing rows for examples).
- `documentation` — URL to the API's documentation.
- `license` — short licence name, or blank.
- `maintainer` — contact email or team name.
- `areaServed` — geographic area, or blank.
- `provider` — **must match an `id` in `data/organisation.csv`** (e.g. `government-digital-service`, `nhs-digital`). This is how APIs are grouped under departments.

### `data/organisation.csv`

Header row:

```
id,name,alternateName,url
```

- `id` — kebab-case slug (e.g. `cabinet-office`). This is the value that `provider` columns in `catalogue.csv` will reference.
- `name` — full department name.
- `alternateName` — short form / acronym (e.g. `GDS`).
- `url` — department homepage, or blank.

## Step-by-step

1. **Fork** the repository at <https://github.com/co-cddo/api-catalogue> (or work on a branch if you have write access).
2. **Create a branch** for your change:

    ```sh
    git checkout -b bulk-update-<your-department>
    ```

3. **Edit the CSV files** — add or update rows in `data/catalogue.csv`, and add any new organisations to `data/organisation.csv`. Keep existing rows untouched unless you are deliberately updating them.
4. **Preview the site** (optional but encouraged for large changes):

    ```sh
    bundle exec middleman server
    # then open http://localhost:4567
    ```

5. **Commit** with a clear message:

    ```sh
    git add data/catalogue.csv data/organisation.csv
    git commit -m "Add <N> APIs for <Department Name>"
    ```

6. **Open a pull request** against `main`. In the description, list:
    - The organisation(s) involved
    - How many APIs are being added, updated, or removed
    - A contact for questions

7. A maintainer will review and merge. Once merged, deployment is automatic
   (see [deployment.md](./deployment.md)).

## Common pitfalls

- **`provider` does not match an organisation `id`** — the API will be silently dropped from the rendered site. `bin/test bulk` catches this.
- **Mixed line endings** — keep CSV files using LF. Some spreadsheet apps export CRLF.
- **Spreadsheet auto-formatting** — Excel/Numbers may convert dates or strip leading zeros. Prefer editing the file in a text editor, or export with explicit ISO date formatting.
- **Adding a new organisation but forgetting to update `organisation.csv`** — every `provider` value must have a matching row.
