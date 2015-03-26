# Glasir Demo

This repository contains a demonstration of the Glasir framework. Below you will find some information about how to download, build and run the code in this project.

## Prerequisites

You will need to have a reasonably sized development machine, with at least 8Gb of RAM, at least 1Gb free disk space and for software you'll need git 1.7+ and Java 6 installed.

Open up a terminal and verify your java version with the command `java -version`. It is important that your java version gets reported as 1.6 (commonly referred to as java 6). If you see 1.7, 1.8 or something else other than 1.6, take steps necessary to install and enable java 1.6.

Your git version should report as something higher than 1.7. You can find out what you have by running `git --version` in a terminal window.

Glasir runs well on Linux and Mac OS X. Limited testing has been performed on Windows.

## Cloning the Repository

First off, pull down the source code by cloning this git repository:

```git clone https://github.com/iteego/glasir.demo.git```

You should get a folder called glasir.demo on your local machine.

##  Building the Source Code

Once you have the source code, you can issue the following command in the root directory of the subversion branch/trunk to run a full build cycle:

```./gradlew cleanAll devDeploy```

(replace with gradlew.bat for windows environments). The first time you run this, glasir will download the appropriate versions of ATG and JBoss and ask you to accept the licensing terms. The task will then clean out all build artifacts, compile the code, test the code, and run the ATG assembler which in turn will assemble an ear file. In other words, to build the project, all you need is java and a copy of the source. 

## Starting the Development Store Instance

Glasir in general relieves you from the onus of configuring and setting up a database. For development, glasir uses a in-memory/on-disk instance of the h2 database which is automatically started when you start your jboss node and auto-populated with the necessary seed data when you start up your node. You can also configure the application to use an external instance of Oracle or any other database supported by the contained application - which in the glasir.demo case happens to be ATG 10.

You can then start the development store instance by issuing:

```./gradlew startDevStore```

This is essentially the full development build cycle. There are a large number of other build tasks, but these should cover the normal build, test, deploy, start jboss scenarios.

Once the log output indicates that the server node is up and running, you should be able to open a browser and load the page [http://localhost:10080/glasir].

## Technologies to Familiarize Yourself With

It might also be useful to be familiar with the testing frameworks used by the project:

* The spock BDD framework: [https://code.google.com/p/spock/]. This is a behavior driven development framework and a JUnit replacement. Spock replaces JUnit with a very powerful and concise groovy based test language, support for datadriven testing, and a BDD centric philosophy which makes it very powerful and actually fun to use.
* The geb functional testing framework: [http://www.gebish.org/]. We use geb for automated web testing (i.e. logging in to the site, placing an order, etc). Geb uses the spock language as a base and extends it with functionality and concepts required for functional web testing.
it should be noted that the project currently uses the above two frameworks and any testing in general very sparingly. The plan is to change this going forward. Specifically we are interested in automating smoke tests of some basic site functionality to enable CI server based smoke tests for the upgrade project. Whether or not this will happen within the scope of this project is to be determined.

## Questions?

The Iteego team wish you all Happy Glasir Development. If you have any questions at all, please do not hesitate to submit a ticket to this project.
