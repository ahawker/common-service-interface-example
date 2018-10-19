# Bump

This document outlines the interface(s) exposed for modifying service versions.

## Extension

Version modification is supported by the [bump](../.cri/extensions/bump) extension.

Run the following for more details:

```bash
$ cri bump:help

Command:
  cri bump

Usage:
  cri <target>

Targets:
  help                 Show command help/usage
  major                Bump to next major version, e.g. 2.1.1 -> 3.1.1
  minor                Bump to next minor version, e.g. 0.2.1 -> 0.3.1
  patch                Bump to next patch version, e.g. 0.0.2 -> 0.0.3
```

### Related

This extension works closely with the following:

* [Release](docs/release.md)
* [Continuous Integration](docs/ci.md)
* [Continuous Deployment](docs/cd.md)

## Interface

The [bump](../.cri/extensions/bump) extension exposes **three** targets that must be implemented to conform.

### major

```bash
$ cri bump:major
```

#### Execution

The `major` target executes the `scripts/bump/bump` script and passes in `major` as the first argument.

#### What is a "major" change?

Simply put, a "major" version change should happen whenever you make an incompatible API change.

#### Expectations

When upgrading a dependency that has changed its _major_ version, it is expected that this will **break** backwards compatibility.

### minor

```bash
$ cri bump:minor
```

#### Execution

The `minor` target executes the `scripts/bump/bump` script and passes in `minor` as the first argument.

#### What is a "minor" change?

Simply put, a "minor" version change should happen whenever you add new functionality in a backwards compatible manner.

#### Expectations

When upgrading a dependency that has changed its _minor_ version, it is expected that this will not break backwards compatibility.

### patch

```bash
$ cri bump:patch
```

#### Execution

The `patch` target executes the `scripts/bump/bump` script and passes in `patch` as the first argument.

#### What is a "patch" change?

Simply put, a "patch" version change should happen whenever you perform backwards compatible bug fixes.

#### Expectations

When upgrading a dependency that has changed its _patch_ version, it is expected that this will not break backwards compatibility.

## Philosophy

Simply put, follow [semver](https://semver.org/).

## Who/What changes the version?

Historically, automatic version changing was linked to Continuous Integration systems and their build numbers. However, in a world with [semver](https://semver.org/) and [Continuous Deployment](https://en.wikipedia.org/wiki/Continuous_delivery), this has fallen out of favor. These days, there are a few different ways to approach it:

* Human control
* Automated control via commit message specification

### Human Control

Generally speaking, humans (the code author) are going to know best _what_ is contained within a commit/pull request and whether or not it should be a `patch`, `minor`, or `major` change.

#### How to enforce?

This can be a manual or automated process. In a manual process, the original developer and developer(s) performing the code review can agree upon the next version. The pull request would contain the version changes necessary.

If you wanted this to be a semi-automated processes, you could build upon a branch naming schema, e.g. `bug/patch/platform-2311-fix-org-fields`. Post merge of the pull request, the Continuous Integration system would be able to bump the correct version based on a regex pattern match of the branch name.

### Future Considerations

The following is a working list of items up for potential consideration in the future:

* Enforce code commit structure to automatically detect version changes [semantic-release](https://github.com/semantic-release/semantic-release)

### Links

Prior art, additional documentation, thoughts, etc.

* https://semver.org/
