# Build Apache Kafka for Debian-based Systems 

This repo contains a way to build Debian packages for Kafka from binary tarballs
designed to be used with another automated configuration management system that
will ensure the JVM and service scripts are also installed.

## Usage

1. Get the URL to the tarball you'd like to package from the Kafka Site at
   http://kafka.apache.org/downloads.html

2. Use the build tool to download the tarball and build the packages:

        $ ./build-from-url.sh <url>

## Footnotes

* There are no start/stop scripts included. This is up to you to provide.

* The package intentionally has no JDK/JVM dependency. This is up to you
  to enforce.

* Use the ```clean.sh``` script to start over again.
