#!/bin/bash

set -e

hg clone http://hg.openjdk.java.net/jdk8/jdk8/langtools langtools
cd langtools

for i in $(grep -r -l 'System.exit' src/share/classes); do
  sed -i -e 's/System.exit/String.valueOf/g' $i
  echo "Patched: $i"
done

ant -buildfile make/build.xml -Dboot.java.home=${JAVA_HOME}

cd ../

git clone --depth=1 https://android.googlesource.com/platform/dalvik
cd dalvik/dx

shopt -s globstar

cd src
javac -source 7 -target 7 ./**/*.java
cd ../
jar -cfm dx.jar etc/manifest.txt src/**/*.class
cp dx.jar ../../langtools/build/bootstrap/lib/dx.jar

cd ../../
