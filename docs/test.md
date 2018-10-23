# Test

This document outlines the interface(s) exposed to support running service tests.

## Extension

Test execution is supported by the [test](../.cri/extensions/test) extension.

Run the following for more details:

```bash
$ cri test
Command:
  cri test

Usage:
  cri test:<target>

Targets:
  %                    Run tests in scripts/% file
  all                  Run all isolated and integrated tests
  help                 Show command help/usage
  isolated             Run tests for service when running in isolation
  integrated           Run tests for service when running integrated with dependencies
  unit                 Run unit tests
  ui                   Run user interface tests
```

### Related

This extension works closely with the following:

* [Continuous Integration](docs/ci)
  * [TravisCI](docs/travisci)
* [Coverage](docs/coverage)

## Interface

The [test](../.cri/extensions/test) extension exposes **three** targets that must be implemented to conform.

### isolated

```bash
$ cri test:isolated
```

#### Execution

The `isolated` target executes all scripts in the `scripts/test/isolated` directory. These scripts should only contain commands to run tests that are capable of succeeding without any external dependencies.

#### What is "isolated"?

Many applications have external dependencies:

* Databases (PostgreSQL, MongoDB)
* 3rd-party services (Sendgrid)
* Cloud storage (S3)
* Company developed services (SoA, Microservices)

With that in mind, "isolated" means that the service tests can be run successfully in an environment that cannot communicate with **ANY** of the above. This means that the following conditions hold true:

* Tests do not exercise integration interfaces with external dependencies
* Tests uses stub/mock interfaces
* Tests uses in-memory/in-process replacements

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri test:isolated
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri test:isolated ; echo $?
Running unit tests...
Running module integration tests...
Running swagger generation tests...
0
```

Any non-zero exitcode will be considered a test failure.

##### Output

The `isolated` target should decide to write output at a reasonable verbosity level to `stdout` and/or `stderr`. The output should contain information about which tests failed, why they failed, and any stack traces/failed assertions generated. The output will be consumed by humans in both local and continuous integration environments and should be formatted with that in mind.

##### Implementation

How does a service implement the `isolated` target? Simply put, invoke your test scripts/test runners inside scripts within the `scripts/test/isolated` directory.

**Example:**

```bash
$ cat scripts/test/isolated/property
#!/usr/bin/env sh

py.test -v -m "property"
```

### integrated

```bash
$ cri test:integrated
```

#### Execution

The `integrated` target executes all scripts in the `scripts/test/integrated` directory. These scripts should only contain commands to run tests that are capable of succeeding without any external dependencies.

#### What is "integrated"?

Building off the example outlined in the "isolated" section above, "integrated" means that the service tests can be run successfully **IFF** its external dependencies are running and available. This means that:

* Tests use real databases to perform real actions
* Tests use real code implementations without stub/mock functionality

#### How to conform?

The following command must return an exitcode of 0:

```bash
$ cri test:integrated
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri test:integrated ; echo $?
Running Postgres DAO tests...
Running Sendgrid tests...
Running Kafka consumer tests...
0
```

Any non-zero exitcode will be considered a test failure.

##### Output

The `integrated` target should decide to write output at a reasonable verbosity level to `stdout` and/or `stderr`. The output should contain information about which tests failed, why they failed, and any stack traces/failed assertions generated. The output will be consumed by humans in both local and continuous integration environments and should be formatted with that in mind.

##### Implementation

How does a service implement the `integrated` target? Simply put, invoke your test scripts/test runners inside scripts within the `scripts/test/integrated` directory.

**Example:**

```bash
$ cat scripts/test/integrated/benchmarks
#!/usr/bin/env sh

py.test -v tests/benchmarks
```

#### "isolated" vs. "integrated"

* A set of "isolated" tests **MUST** run in any environment as long as all software dependencies are installed.
* A set of "integrated" tests **MUST FAIL** running in an isolated environment.
* A set of "isolated" tests **MUST** run and succeed in the "integrated" test environment.

### all

```bash
$ cri test:all
```

#### Execution

The `all` target executes both the `isolated` and `integrated` targets (in that order) and requires both of them to succeed. This target is used at later stages of continuous integration environments to validate all changes prior to deployment.

### Adding your own targets

If you look at the example at the very top of this document, you'll see that there are some examples of custom targets: `cri test:unit` and `cri test:ui`. It's perfectly acceptable for services to add their own custom scripts/targets to simplify development for _that_ service. This can be helpful as services _amy_ have slightly different definitions of what "integration" tests or "functional" tests are.

#### Caveats/Notes

You do not need to add a target to invoke a custom script.

Imagine you want to create a collection of tests called `performance`. You can run them in the following ways:

* Place the script within `scripts/test/isolated` or `scripts/test/integrated` and it will automatically be called by the respective target.
* The `cri test` extension supports pattern matching, so `cri test:performance` will run, **IFF** a script named `performance` can be found. If you wish to add an entry for this to `cri test:help`, you'll have to add a target for it to the [test cri file](../.cri/extensions/test/cri).

Please note that if your custom scripts are not located with `scripts/test/isolated`/`scripts/test/integrated` or defined as target prerequisites in the [test cri file](../.cri/extensions/test/cri), they **WILL NOT BE RUN** by the [Continuous Integration](../.cri/extensions/ci) extension.

### Future Considerations

The following is a working list of items up for potential consideration in the future:

* How code coverage is generated/gathered/reported as it relates to test execution
* Defined output formats (stdout/stderr) for test execution
* Defined file artifacts generated _by_ test execution
* Defined file artifact locations generated _by_ test execution
* Enforcing a `cri test:unit` target to enforce developers to implement as least one test

### Links

Prior art, additional documentation, thoughts, etc.
