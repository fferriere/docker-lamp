#!/bin/bash

MY_PATH=$(dirname $(realpath $0))

docker build -t fferriere/aphpache $MY_PATH/.
