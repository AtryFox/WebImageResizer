#!/usr/bin/env bash

cd $(dirname $0)

git reset HEAD --hard
git pull
git rev-parse --short=4 HEAD > version