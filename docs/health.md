# Health

This document outlines the interface(s) exposed to support checking the health of a service.

## Extension

Health checks are supported by the [health](../.cri/extensions/health) extension.

Run the following for more details:

```bash
$ cri health:help
Command:
  cri health

Usage:
  cri health:<target>

Targets:
  %                    Run health check in scripts/% file
  all                  Run all health checks
  help                 Show command help/usage
  liveness             Run liveness check against running instance of repository
  readiness            Run readiness check against running instance of repository
```

## Interface

The [health](../.cri/extensions/health) extension exposes two targets that must be implemented to conform.

### liveness

```bash
$ cri health:liveness
```

#### Execution

The `liveness` target executes the `scripts/health/liveness` script. This script should contain one or more commands necessary to determine if the current service instance is alive.

#### What is "alive"?

Many applications run for long periods of time, performing work without user notification. This check should be used to determine when the application is alive/running and has not entered a state in which it cannot continue/recover.

#### Guarantees

A service should be considered **ALIVE** when:

* A process is running
* A process is responding through some interaction channel

An **ALIVE** service does not mean the following:

* It's working _correctly_
* It's ready for traffic/load
* It's capable of support one or more expected workloads
* It will remain in this state forever

#### How to conform?

##### Exitcode

The following commands must return an exitcode of 0:

```bash
$ cri health:liveness
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri health:liveness ; echo $?
Running scripts/liveness...
DEAD!
2
```

Any non-zero exitcode will be considered a failure and the service deemed **DEAD**.

##### Output

The `liveness` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only.

#### Implementation

How does a service implement the `liveness` check? Simply put, implement the checking code/logic in the `scripts/health/liveness` script.

##### Socket Servers

In many cases, the application will be a service that is listening on a TCP socket speaking HTTP/HTTPS. In this case, the service should implement the `/health/liveness` route and return a `200 OK` response when it is alive.

The service _may_ decide to write back a response body as well but it is not required.

A simple implementation of such a check can be imagined as:

```bash
$ cat scripts/health/liveness
#!/usr/bin/env sh

wget --quiet --spider http://localhost:5001/health/liveness
```

##### Worker Processes

In many cases, the application will be a worker type process that is constantly pulling work from a queue and performing its desired action. In this case, the service could implement a simple check to see if there is a PID running the expected process.

A simple implementation of such a check can be imagined as:

```bash
$ cat scripts/health/readiness
#!/usr/bin/env sh

ps axo pid,command | grep "[p]ython"
```

### readiness

```bash
$ cri health:readiness
```

#### Execution

The `readiness` target executes the `scripts/health/readiness` script. This script should contain one or more commands necessary to determine if the current service instance is alive.

#### What is "ready"?

There are many cases where applications are alive but are not in a state capable of performing their proper function. A socket server running but not yet bound to a port, a process loading configuration files at start, or an HTTP server that cannot communicate to its external database. This check should be used to determine when the application is alive but not yet ready to perform its duty.

#### Guarantees

A service should be considered **READY** when:

* It is **ALIVE**
* It's ready for traffic/load
* It's available to handle most of the expected workloads, sans exception cases
* It's external dependencies are **ALIVE** and **READY**

A **READY** service does not mean the following:

* It's working _correctly_ with no exceptions
* It's capable of support one or more expected workloads
* It will remain in this state forever

#### How to conform?

##### Exitcode

The following commands must return an exitcode of 0:

```bash
$ cri health:readiness
```

In many shell environments, you can check the exitcode of the previous process with `$?`. For example:

```bash
$ cri health:readiness ; echo $?
Running scripts/readiness...
READY!
0
```

Any non-zero exitcode will be considered a failure and the service deemed "not ready".

##### Output

The `readiness` target _may_ decide to write output to `stdout` or `stderr` but it is not required. If you chose to do so, best practices would dictate that you keep it to a minimum and helpful to a developer/operator for debugging purposes only. Consider indicating _why_ the application is not ready.

#### Implementation

How does a service implement the `readiness` check? Simply put, implement the checking code/logic in the `scripts/health/readiness` script.

##### Socket Servers

In many cases, the application will be a service that is listening on an HTTP/HTTPS socket. In this case, the service should implement the `/health/readiness` route and return a `200 OK` response when it is alive.

The service _may_ decide to write back a response body as well but it is not required.

A simple implementation of such a check can be imagined as:

```bash
$ cat scripts/health/readiness
#!/usr/bin/env sh

wget --quiet --spider http://localhost:5001/health/readiness
```

##### Worker Processes

In many cases, the application will be a worker type process that is constantly pulling work from a queue and performing its desired action. In this case, the service could be implemented to periodically write out it's read position in the queue to a file. In this case, the service could implement a simple check to see if the file exists and if its last-modified time is monotonically increasing at the expected rate.

A simple implementation of such a check can be imagined as:

```bash
$ cat scripts/health/readiness
#!/usr/bin/env sh

find /tmp/service/readiness -mtime -30s
```

### Liveness vs. Readiness

The easiest way to think about the differences is with a simple scenario: An HTTP service for a CRUD app backed by a relational database like [PostgreSQL](https://www.postgresql.org/).

When determining the overall health of _our_ service, we want to include the health of our external database as well, right? We cannot operate without it. In this case, we want to put it in the `readiness` check and not the `liveness` check. Why?

If database health was included in our `liveness` check, we would deem all of our services **DEAD** whenever our database encountered an error. This scenario is incorrect. Our service is still alive but our database is dead. If the service is plugged into a system with automatic healthchecking to add/remove instances deemed **DEAD**, we're going to constantly be cycling through services that are alive but immediately get killed because the database is down.

If the database health was included in our `readiness` check, we would deem all of our services **ALIVE** but **NOT READY** to receive traffic. They would continue running and if running in a proper system, would have traffic routed away from them until the database was alive and healthy again.

## Future Considerations

The following is a working list of items up for potential consideration in the future:

* Defined output responses (stdout/stderr) or HTTP response bodies for `liveness` and/or `readiness` checks
  * GOAL: Provide additional information beyond binary state of yes/no
* Strictly define the HTTP routes for `liveness` and `readiness`
  * `/health/liveness` and `/health/readiness` are the examples shown above
* Strictly define communication channel for non-socket listening services
* Separate endpoint for explicit checking of `liveness` and/or `readiness` of JUST external dependencies

## Links

Prior art, additional documentation, thoughts, etc.

* https://docs.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring
* https://microservices.io/patterns/observability/health-check-api.html
* https://docs.docker.com/engine/reference/builder/#healthcheck
* https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
