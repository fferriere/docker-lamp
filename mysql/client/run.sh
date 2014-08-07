#!/bin/bash

docker run -t -i --rm \
  --volumes-from fferriere-mysql-server \
  --link fferriere-mysql-server:mysql \
  fferriere/mysql-client $@
