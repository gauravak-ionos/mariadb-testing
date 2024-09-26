**Table of Contents**
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Run the tests locally](#run-the-tests-locally)
- [Test environments](#test-environments)
- [Test execution](#test-execution)


## Introduction

**Karate** is an open-source tool developed by "intuit".It is a framework that combine API test-automation, mocks, performance-testing and even UI automation into a single, unified framework. The BDD syntax popularized by Cucumber is language-neutral, and easy for even non-programmers. Powerful JSON & XML assertions are built-in, and you can run tests in parallel for speed.

## Prerequisites
The project is developed in Java with Maven, so the framework requires the following software:

* atleast [Java 11](https://www.oracle.com/java/technologies/downloads/)
* [Apache Maven](https://maven.apache.org)
* Your favorite IDE: To run features or scenarios tests
    * [Intellij IDEA](https://www.jetbrains.com/)
    * [VS Code](https://code.visualstudio.com/)

## Run the tests locally

To execute tests in your local machine, enter the root folder and execute any of the following commands to install the dependencies and start up the test runners one by one.

* The user who wants to execute the tests, MUST provide a valid TOKEN.

```
mvn clean test -Dtest=TestRunner
```
To execute a specific feature file:
```
mvn clean test -Dkarate.env=qa -Dkarate.options=classpath:com/ionos/cloud/paas/features/example-authentication-validations.feature
```

## Test environments
Our test infrastructure has 2 environments. All of them are assigned to one cloud contract, so same token works for all.
* ``dev``: this is dedicated to developers as their playground(Unit and Integration tests)
* ``qa``: this is used by QA colleagues (Smoke tests, End-to-End tests, Regression tests and load tests)

## Test execution
> [!NOTE]
> We have implemented workflows in our Github Actions, in which our tests are executed not only regularly in ``qa``, and ``stage`` environments but also especially before and after pull-request creation for new software rollouts

To execute particular test features that are available in this project. Please use the appropriate ``--tags``

> [!IMPORTANT]
> if no tags are provided, test suite will execute all the feature files.

* @regressionTest: all the features without load tests consists this tag

```
mvn clean test -Dkarate.env=qa -Dkarate.options="--tags @regressionTest"
```

### How-To execute load tests

We have integrated Karate and Gatling. We could re-use our karate feature files for load tests
* Load models are implemented in ``scala``

We make use of two types of Gatling injection profiles: __rampUsers__, __stressPeakUsers__. More details about Gatling injection profiles can be found in the [documentation](https://gatling.io/docs/gatling/reference/current/core/injection/).

Load tests can be triggered from the `Load Tests` github action in this repo. It's possible to customize the number of users, the duration, and the environment against which the tests are run using the action inputs

- _user_: the number of users to be used, defaults to 5
- _duration_: the duration of the simulation in seconds, defaults to 200
- _test_feature_: the test feature for this simulation, possible values: any feature file from folder /features (default is sample-load-tests.feature)
- _injection_type_: the injection type for Gatling, possible values: ramp_users (default), stress_peak_users

To run a default settings (sample-tests feature with 5 users and 200 durations:
for the initial tests use lower numbers of users and duration to avoid overloading the system cache
```
mvn clean test-compile gatling:test -Dkarate.env=qa -Dgatling.simulationClass=LoadTestSimulation
```

For example to run a scenario for 20 users with a duration of 60 seconds for feature "002-extended-tests":
```
mvn clean test-compile gatling:test -Dkarate.env=qa -Dgatling.simulationClass=LoadTestSimulation \
 -Duser=20 -Dduration=60 -Dtest_feature=sample-tests.feature
```
To run a scenario with a __stressPeakUsers__ injection profile:
```
mvn clean test-compile gatling:test -Dkarate.env=qa -Dgatling.simulationClass=LoadTestSimulation \
 -Duser=20 -Dduration=60 -Dtest_feature=sample-tests.feature -Dinjection_type=stress_peak_users
```

Gatling properties can be customized by editing the gatling.conf and adding `-Dgatling.conf.file=gatling.conf`

## Directory structure

```
src/test/java
    |
    +-- karate-config.js # Enironment specific variables are defined here
    +-- logback-test.xml # logging can be modified here `DEBUG`, `INFO`, `ERROR` 
    +-- gatling.conf # Gatling specific variables are defined here
    +-- LoadTestSimulation.scala # Load Models are implemented here
    +-- bashscript.sh # Test execution script with TokenID(user-specific file NOT include in git)
    |
    \-- com.ionos.cloud.paas
        +-- TestRunner.java
        |--features
            |   +-- xx.feature
            |   +-- xx.feature
            |   +-- xx.feature
```

## Reference Documentation
* [Karate official Repo](https://github.com/intuit/karate)

