#!/bin/bash

set -e

git config --global user.email $(git log -n 1 --pretty='format:%aE')
git config --global user.name $(git log -n 1 --pretty='format:%aN')

cd langtools/build/bootstrap
git init
git add .
git commit --quiet -m "Deploy to Github Pages"
git push --force "https://${GITHUB_TOKEN}@github.com/TheBrokenRail/langtools-build.git" master:gh-pages
