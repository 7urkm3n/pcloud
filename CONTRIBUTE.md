#### How to contribute ?

Conventional Commits
Here is a brief overview of the important prefixes, pulled from https://github.com/google-github-actions/release-please-action#whats-a-release-pr

The most important prefixes you should have in mind are:

- <b>fix:</b> which represents bug fixes, and correlates to a SemVer patch.
- <b>feat:</b> which represents a new feature, and correlates to a SemVer minor.
- <b>feat!:</b>, or <b>fix!:</b>, <b>refactor!:</b>, etc., which represent a breaking change (indicated by the !) and will result in a SemVer major.

  I’ve considered doing a longer article about how I use conventional commit messages in my workflow, so let me know if you’d be interested in that.


## Releasing a new version

Releasing the new version is required only by creating Pull Request, Please use `release` branch for it. Rest of the part github.actions will do the job.