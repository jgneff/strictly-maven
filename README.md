[Apache Maven][maven] is a build automation tool used primarily for Java projects. Maven can also be used to build and manage projects written in C#, Ruby, Scala, and other languages. Maven projects are configured with a Project Object Model (POM) in a `pom.xml` file.

This package provides Maven for Linux and uses the [OpenJDK Snap package][openjdk], if installed, when the `JAVA_HOME` environment variable is not set. Building this package downloads the Maven source code directly from the [Apache Web site][source], verifies its SHA-512 hash value, and builds Maven from source using the Ubuntu Maven package.

Java and OpenJDK are trademarks or registered trademarks of Oracle and/or its affiliates.

[maven]: https://maven.apache.org/
[openjdk]: https://snapcraft.io/openjdk
[source]: https://downloads.apache.org/maven/maven-3/
