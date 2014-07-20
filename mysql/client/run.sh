#!/bin/bash

NAME='fferriere-mysql-client'

docker run -t -i \
  --name $NAME \
  --volumes-from fferriere-mysql-server \
  --link fferriere-mysql-server:mysql \
  fferriere/mysql-client
