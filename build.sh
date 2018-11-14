#!/bin/bash

set -e

hg clone http://hg.openjdk.java.net/jdk8/jdk8/langtools langtools
cd langtools

for i in $(grep -r -l 'System.exit' src/share/classes); do
  sed -i -e 's/System.exit/if (true) { throw new SecurityException(); }; String.valueOf/g' $i
  echo "Patched: $i"
done

ant -buildfile make/build.xml -Dboot.java.home=${JAVA_HOME} build-bootstrap-tools

cd ../

git clone --depth=1 https://android.googlesource.com/platform/dalvik
cd dalvik/dx

shopt -s globstar

for i in $(grep -r -l 'System.exit' src); do
  sed -i -e 's/System.exit/if (true) { throw new SecurityException(); }; String.valueOf/g' $i
  echo "Patched: $i"
done

javac -source 8 -target 8 src/**/*.java
cd src
jar -cfm ../dx.jar ../etc/manifest.txt ./**/*.class
cd ../
cp dx.jar ../../langtools/build/bootstrap/lib/dx.jar

cd ../../
