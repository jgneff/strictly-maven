## Summary

[Apache Maven](https://maven.apache.org) is a build automation tool used primarily for Java projects. Maven can also be used to build and manage projects written in C#, Ruby, Scala, and other languages. Maven projects are configured using a Project Object Model stored in a `pom.xml` file.

This repository creates the [Strictly Maven Snap package](https://snapcraft.io/strictly-maven), which provides the latest release of Maven built directly from its [source code](https://github.com/apache/maven) on GitHub. If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is also installed, this package connects to it automatically for the location of its Java Development Kit runtime and tools.

This Snap package is **strictly confined**, running in complete isolation with only limited access to your home directory and network. This project is an experiment to determine whether Maven can run in a restricted environment. Please install this Snap package only if you're interested in such a test.

## Motivation

It's getting more and more difficult for Linux distributions to keep up with every new release of the various developer tools. As a result, their package repositories are getting more and more [out of date](https://packages.ubuntu.com/search?keywords=maven&searchon=names&exact=1).

One alternative is to get these tools directly from their upstream projects. Yet that often involves a tedious series of tasks, such as tracking the updates, downloading each new release, trusting the build infrastructure, verifying the checksum and signatures, unpacking the archive, and setting up the environment variables. In the case of Maven, the tool downloads hundreds of files on its first invocation, by default without even verifying the integrity of the downloaded artifacts.

I wanted a release of Maven that was:

* built directly from source, identified strictly by its Git release tag or branch,
* built transparently, using transient containers created from trusted images,
* downloaded, verified, and installed automatically with each update,
* confined strictly, having limited access to my development workstation, and
* configured to strictly verify the checksum of each artifact that it downloads.

The Strictly Maven Snap package created by this repository does just that. It's actually easier for me to keep this Snap package up to date than it is to track, download, trust, verify, unpack, and set up each new release from Apache.

## Usage

### Trust

The steps in building the packages are open and transparent so that you can gain trust in the process that creates them instead of having to put all of your trust in their publisher. Below is a link to each step of the build process:

* [Snap Source](snap/snapcraft.yaml) - build file used to create the Snap package
* [Maven Source](https://github.com/apache/maven/tags) - release tags used to obtain the Maven source code
* [Snap Package](https://launchpad.net/~jgneff/+snap/strictly-maven) - information about the package and its latest builds
* [Snap Listing](https://snapcraft.io/strictly-maven) - listing for the package in the Snap Store

The [Launchpad build farm](https://launchpad.net/builders) runs each build in a transient container created from trusted images to ensure a clean and isolated build environment. It's the same build farm that creates the Debian packages installed on my Ubuntu system, so I'm already trusting its build infrastructure by running Ubuntu. Snap packages built on Launchpad include a manifest file, called `manifest.yaml`, that lets you verify the build and identify its dependencies.

### Install

Install the Strictly Maven Snap package with the command:

```console
$ sudo snap install strictly-maven
```

The Snap package is [strictly confined](https://snapcraft.io/docs/snap-confinement) and adds only the following interfaces to its permissions:

* the [home interface](https://snapcraft.io/docs/home-interface) to read and write files under your home directory, and
* the [network interface](https://snapcraft.io/docs/network-interface) to download artifacts from remote repositories like Maven Central.

If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is also installed, the Strictly Maven Snap package connects to it automatically for its JDK runtime and tools. You can connect them manually with the command:

```console
$ sudo snap connect strictly-maven:jdk-18-1804 openjdk
```

Once installed and connected, you'll see the following interfaces:

```console
$ snap connections strictly-maven
Interface             Plug                        Slot                 Notes
content[jdk-18-1804]  strictly-maven:jdk-18-1804  openjdk:jdk-18-1804  -
home                  strictly-maven:home         :home                -
network               strictly-maven:network      :network             -
```

You may use a different Java Development Kit by setting the `JAVA_HOME` environment variable, but because the Strictly Maven Snap package is strictly confined, the JDK must be located in a non-hidden folder of your home directory.

### Run

You can put the following alias in your `~/.bash_aliases` file to be able to run the Strictly Maven Snap package using the normal Maven `mvn` command:

```bash
alias mvn='strictly-maven'
```

Verify that the Strictly Maven Snap package is working and connected to the OpenJDK Snap package with the following commands:

```console
$ type mvn
mvn is aliased to `strictly-maven'
$ mvn --version
Apache Maven 3.8.5 (3599d3414f046de2324203b78ddcf9b5e4388aa0)
Maven home: /snap/strictly-maven/2/maven
Java version: 18.0.1.1, vendor: Snap Build, runtime: /snap/strictly-maven/2/jdk
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "5.13.0-44-generic", arch: "amd64", family: "unix"
```

Then switch to a Maven project directory and try running the `mvn clean` command. If this is the first time, you'll see Maven downloading the plugins required for the `clean` phase.

The Snap package does not have access to hidden files or folders in your home directory, such as the default Maven `~/.m2` directory, so it uses the following alternative locations:

| Normal Maven         | Strictly Maven |
|----------------------|----------------|
| `~/.m2/settings.xml` | `~/snap/strictly-maven/common/settings.xml` |
| `~/.m2/repository`   | `~/snap/strictly-maven/common/repository`   |

The Snap package [runs Maven](bin/maven.sh) with a command equivalent to the following:

```bash
/snap/strictly-maven/current/maven/bin/mvn --strict-checksums \
    --settings ~/snap/strictly-maven/common/settings.xml "$@"
```

### Build

You can build the Snap package on Linux by installing [Snapcraft](https://snapcraft.io/snapcraft) on your development workstation. Run the following commands to install Snapcraft, clone this repository, and start building the package:

```console
$ sudo snap install snapcraft
$ git clone https://github.com/jgneff/strictly-maven.git
$ cd strictly-maven
$ snapcraft
```

To run the build remotely on Launchpad, enter the command:

```console
$ snapcraft remote-build
```

See the [Snapcraft Overview](https://snapcraft.io/docs/snapcraft-overview) page for more information on building Snap packages.

## License

This project is licensed under the Apache License 2.0, the same license used by the Apache Maven project. Apache Maven and the Maven logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.
