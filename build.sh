#!/bin/bash

set -e

hg clone http://hg.openjdk.java.net/jdk8/jdk8/langtools langtools
cd langtools

for i in $(grep -r -l 'System.exit' src/share/classes); do
  sed -i -e 's/System\.exit/if (true) { throw new SecurityException(); }; String\.valueOf/g' $i
done

ant -buildfile make/build.xml -Dboot.java.home=${JAVA_HOME} build-bootstrap-tools

cd ../

git clone --depth=1 https://android.googlesource.com/platform/dalvik
cd dalvik/dx

shopt -s globstar

mkdir -p src/patch/com/android
mv src/com/android/* src/patch/com/android

for i in src/**/*.java; do
  sed -i -e 's/System\.exit/if (true) { throw new SecurityException(); }; String\.valueOf/g' $i
  sed -i -e 's/com\.android/patch\.com\.android/g' $i
done

javac src/**/*.java
cd src
jar -cf ../dx.jar ./**/*.class
cd ../
cp dx.jar ../../langtools/build/bootstrap/lib/dx.jar

cd ../../

git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
PATH=$(pwd)/depot_tools:${PATH}

git clone --depth=1 https://r8.googlesource.com/r8 -b 1.3.44
cd r8

patch -p1 < ../d8.patch

for i in src/**/*.java; do
  sed -i -e 's/System\.exit/if (true) { throw new SecurityException(); }; String __patch_exitCode__ = String\.valueOf/g' $i
  sed -i -e 's/com\.android/patch\.com\.android/g' $i
  sed -i -e 's/com\/android/patch\/com\/android/g' $i
done

tools/gradle.py d8 r8

cp build/libs/*.jar ../langtools/build/bootstrap/lib

cd ../
