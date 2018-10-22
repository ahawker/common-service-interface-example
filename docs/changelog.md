# Changelog

This document outlines the interface(s) to maintaining the repository changelog.

## Extension

Test execution is supported by the [changelog](../.cri/extensions/changelog) extension.

Run the following for more details:

```bash
$ cri changelog:help
Command:
  cri changelog

Usage:
  cri changelog:<target>

Targets:
  create               Create changelog from git and GitHub metadata
  help                 Show command help/usage
```

### Related

This extension works closely with the following:

* [Continuous Integration](docs/ci)
  * [TravisCI](docs/travisci)
* [Release](docs/release)
* [Bump](docs/bump)

## Interface

The [changelog](../.cri/extensions/changelog) extension exposes **one** target that must be implemented to conform.

### create

```bash
$ cri changelog:create
```

#### Execution

The `create` target executes the `scripts/changelog/create` script. This script must contain the command(s) necessary to modify the repository changelog.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri changelog:create
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri changelog:create ; echo $?
Creating changelog...
0
```

Any non-zero exitcode will be considered a failure.

##### Output

The `create` target may decide to write output to stdout or stderr but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

##### CHANGELOG.md

The `create` target **must** create a file in [Markdown](https://en.wikipedia.org/wiki/Markdown) format named `CHANGELOG.md` that is located in the root of the repository.

#### Default Implementation

If you are using `git` and `GitHub` for your repository, you can skip implementing this target and use the default implementation, which is built on [GitHub Changelog Generator](https://github.com/github-changelog-generator/github-changelog-generator).

The default implementation **requires** the `CHANGELOG_GITHUB_TOKEN` environment variable to be set.

#### Workflow

The changelog should get updated one step after updating the version, see [bump](docs/bump.md), yet before a version tag is created. For a larger view of this, check out the [release](docs/release.md) documentation.

### Future Considerations

* Consider a structured CHANGELOG file format that can be programmatically consumed.

### Links

Prior art, additional documentation, thoughts, etc.

* https://keepachangelog.com/en/0.3.0/
* https://github.com/github-changelog-generator/github-changelog-generator
