#!/bin/bash

set -e

hg clone http://hg.openjdk.java.net/jdk8/jdk8/langtools langtools
cd langtools

for i in $(grep -r -l "System.exit" src/share/classes); do
  sed -i -e 's/System.exit/throw new java.lang.RuntimeException/g' $i
  echo "Patched: $i"
done

ant -buildfile make/build.xml -Dboot.java.home=${JAVA_HOME}
