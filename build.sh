#!/bin/bash

set -e

hg clone http://hg.openjdk.java.net/jdk10/jdk10/langtools langtools
cd langtools

ant -buildfile make/build.xml -Dboot.java.home=${JAVA_HOME}
