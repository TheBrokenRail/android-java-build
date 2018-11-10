#!/bin/bash

set -e

hg clone http://hg.openjdk.java.net/jdk11/jdk11/langtools langtools
cd langtools

ant -buildfile make/build.xml -Dboot.java.home=${JAVA_HOME}
