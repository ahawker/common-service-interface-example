# Shell

This document outlines the interface(s) exposed for creating a shell/console into a service.

## Extension

Shells are supported by the [shell](../.cri/extensions/shell) extension.

Run the following for more details:

```bash
$ cri shell:help

Command:
  cri shell

Usage:
  cri shell:<target>

Targets:
  %                    Run shell script in scripts/% file
  help                 Show command help/usage
  run                  Run console/shell interface into running instance of repository
```

## Interface

The [shell](../.cri/extensions/shell) extension exposes one target that must be implemented to conform.

### run

```bash
$ cri shell:run
```

#### Execution

The `run` target executes the `scripts/shell/run` script. This script should contain one or more commands necessary to shell into the service.

#### What am I shell-ing into?

When running this target, the expectation is that you will receive an interactive prompt into the service that has _just_ started. This command should start the service anew, not connect to an existing one.

#### How to conform?

##### Exitcode

The exitcode of this target is ignored.

##### Output

This target does not create output so much as it connects a TTY for interactivity.

#### Implementation

How does a service implement the `run` target? Simply put, implement the code/logic in the `scripts/shell/run` script.

##### Example

```bash
$ cat scripts/shell/run
#!/usr/bin/env sh

bundle exec rails console
```

### Future Considerations

The following is a working list of items up for potential consideration in the future:

* Should `run` be the default target instead of `help`? `cri shell` vs. `cri shell:run`

### Links

Prior art, additional documentation, thoughts, etc.
