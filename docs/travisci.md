# Travis CI

This document outlines the interface(s) exposed for [Travis CI](https://travis-ci.org) integration.

## Extension

Test execution is supported by the [travis-ci](../.cri/extensions/travis-ci) extension.

Run the following for more details:

```bash
$ cri travis-ci:help

Command:
  cri travis-ci

Usage:
  cri travis-ci:<target>

Targets:
  %                    Run the scripts/% file
  after-deploy         Run script for 'after_deploy' phase
  after-failure        Run script for 'after_failure' phase
  after-script         Run script for 'after_script' phase
  after-success        Run script for 'after_success' phase
  all                  Run all scripts
  before-cache         Run script for 'before_cache' phase
  before-deploy        Run script for 'before_deploy' phase
  before-install       Run script for 'before_install' phase
  before-script        Run script for 'before_script' phase
  deploy               Run script for 'deploy' phase
  help                 Show command help/usage
  install              Run script for 'install' phase
  script               Run script for 'script' phase
```

### Related

This extension works closely with the following:

* [Continuous Integration](docs/ci.md)
* [Continuous Deployment](docs/cd.md)
* [Test](docs/test.md)
* [Coverage](docs/coverage.md)

## Interface

The [travis-ci](../.cri/extensions/travis-ci) extension exposes targets that map directly to Travis CI [phases](https://docs.travis-ci.com/user/for-beginners/#builds-jobs-stages-and-phases).

### Targets

Each of the exposed targets map directly to Travis CI [phases](https://docs.travis-ci.com/user/for-beginners/#builds-jobs-stages-and-phases) within the [.travis.yml](https://docs.travis-ci.com/user/customizing-the-build/) config file.

#### Execution Order

These targets are executed in order as defined by the Travis CI [job lifecycle](https://docs.travis-ci.com/user/job-lifecycle/).

* `before-install`
* `install`
* `before-script`
* `script`
* `before-cache`
* `after-success` or `after-failure` (depending on exitcode of `script`)
* `before_deploy`
* `deploy`
* `after_deploy`
* `after_script`

#### Execution Default

By default, each of these targets executes its named script, e.g. `install` executes `scripts/travis-ci/install`. Each one of these scripts is a no-op and returns an exit code of 0.

### Configuration

Each of the targets will be hooked up to its cooresponding phase in the `.travis.yml` file. That means, that all phases will be hooked up, but no-op until logic is implemented within the script. The downside of this is that any of the language specific default implementations defined by Travis CI will be ignored, e.g. the `install` phase invoking `bundler` for ruby environments.

#### Stages

The `.travis.yml` file is also responsible for defining the Continuous Integration workflow using [stages](https://docs.travis-ci.com/user/build-stages). Check out the [Continuous Integration](docs/ci.md) document for more details.

### before-install

```bash
$ cri travis-ci:before-install
```

#### Execution

The `before-install` target executes the `scripts/travis-ci/before-install` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:before-install
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:before-install ; echo $?
0
```

Any non-zero exitcode will be considered a failure and [error](https://docs.travis-ci.com/user/job-lifecycle/#breaking-the-build) the Travis CI build.

##### Output

The `before-install` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `before-install` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/before-install` script. By default, this script is a no-op and returns an exitcode of 0.

### install

```bash
$ cri travis-ci:install
```

#### Execution

The `install` target executes the `scripts/travis-ci/install` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:install
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:install ; echo $?
echo "Installing dependencies in Travis CI environment..."
0
```

Any non-zero exitcode will be considered a failure and [error](https://docs.travis-ci.com/user/job-lifecycle/#breaking-the-build) the Travis CI build.

##### Output

The `install` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `install` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/install` script. By default, this script is a no-op and returns an exitcode of 0.

### before-script

```bash
$ cri travis-ci:before-script
```

#### Execution

The `before-script` target executes the `scripts/travis-ci/before-script` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:before-script
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:before-script ; echo $?
0
```

Any non-zero exitcode will be considered a failure and [error](https://docs.travis-ci.com/user/job-lifecycle/#breaking-the-build) the Travis CI build.

##### Output

The `before-script` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `before-script` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/before-script` script. By default, this script is a no-op and returns an exitcode of 0.

### script

```bash
$ cri travis-ci:script
```

#### Execution

The `script` target executes the `scripts/travis-ci/script` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:script
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:script ; echo $?
0
```

Any non-zero exitcode will be considered a failure and [fail](https://docs.travis-ci.com/user/job-lifecycle/#breaking-the-build) the Travis CI build.

##### Output

The `script` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `script` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/script` script. By default, this script is a no-op and returns an exitcode of 0.

### before-cache

```bash
$ cri travis-ci:before-cache
```

#### Execution

The `before-cache` target executes the `scripts/travis-ci/before-cache` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:before-cache
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:before-cache ; echo $?
0
```

Any non-zero exitcode will be considered a target failure but the Travis CI build will continue.

##### Output

The `before-cache` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `before-cache` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/before-cache` script. By default, this script is a no-op and returns an exitcode of 0.

### after-success

```bash
$ cri travis-ci:after-success
```

#### Execution

The `after-success` target executes the `scripts/travis-ci/after-success` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:after-success
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:after-success ; echo $?
0
```

Any non-zero exitcode will be considered a target failure but the Travis CI build will continue.

##### Output

The `after-success` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `after-success` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/after-success` script. By default, this script is a no-op and returns an exitcode of 0.

### after-failure

```bash
$ cri travis-ci:after-failure
```

#### Execution

The `after-failure` target executes the `scripts/travis-ci/after-failure` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:after-failure
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:after-failure ; echo $?
0
```

Any non-zero exitcode will be considered a target failure but the Travis CI build will continue.

##### Output

The `after-failure` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `after-failure` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/after-failure` script. By default, this script is a no-op and returns an exitcode of 0.

### before-deploy

```bash
$ cri travis-ci:before-deploy
```

#### Execution

The `before-deploy` target executes the `scripts/travis-ci/before-deploy` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:before-deploy
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:before-deploy ; echo $?
0
```

Any non-zero exitcode will be considered a target failure but the Travis CI build will continue.

##### Output

The `before-deploy` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `before-deploy` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/before-deploy` script. By default, this script is a no-op and returns an exitcode of 0.

### deploy

```bash
$ cri travis-ci:deploy
```

#### Execution

The `deploy` target executes the `scripts/travis-ci/deploy` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:deploy
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:deploy ; echo $?
0
```

Any non-zero exitcode will be considered a target failure but the Travis CI build will continue.

##### Output

The `deploy` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `deploy` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/deploy` script. By default, this script is a no-op and returns an exitcode of 0.

### after-deploy

```bash
$ cri travis-ci:after-deploy
```

#### Execution

The `after-deploy` target executes the `scripts/travis-ci/after-deploy` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:after-deploy
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:after-deploy ; echo $?
0
```

Any non-zero exitcode will be considered a target failure but the Travis CI build will continue.

##### Output

The `after-deploy` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `after-deploy` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/after-deploy` script. By default, this script is a no-op and returns an exitcode of 0.

### after-script

```bash
$ cri travis-ci:after-script
```

#### Execution

The `after-script` target executes the `scripts/travis-ci/after-script` script.

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri travis-ci:after-script
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri travis-ci:after-script ; echo $?
0
```

Any non-zero exitcode will be considered a failure and fail the Travis CI build.

##### Output

The `after-script` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `after-script` check? Simply put, implement the checking code/logic in the `scripts/travis-ci/after-script` script. By default, this script is a no-op and returns an exitcode of 0.

#### Caveats/Notes

If you do not need certain functionality, you're free to ignore implementing a script for the target phase and let it succeed with a no-op.

**WARNING:** If you implement logic in one of the phase handler methods, be aware that it will be invoked for stage within the `.travis.yml` config file.

### Future Considerations

The following is a working list of items up for potential consideration in the future:

* Should there be targets for each CI Workflow stage?

### Links

Prior art, additional documentation, thoughts, etc.

* https://boneskull.com/mocha-and-travis-ci-build-stages/
