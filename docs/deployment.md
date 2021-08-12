# Deployment

The site is hosted on [GitHub pages][github-pages]. When a pull request is
merged into `main` a new version of the site is deployed automatically using
[GitHub actions][github-actions].

## Publishing from your computer

In the event you need to publish a local version of the site from your computer
(not recommended) the following Rake tasks can be run:

```sh
# Not recommended - pull requests are preferred
bundle exec rake build publish
```

These tasks will build the site, checkout the `gh-pages` branch, commit any
changes, and push them to GitHub.

[github-pages]: https://pages.github.com/
[github-actions]: https://docs.github.com/en/free-pro-team@latest/actions
