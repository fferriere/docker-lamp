#!/bin/bash

NAME='fferriere-mysql-server'

docker run -d \
  --name $NAME \
  --volumes-from fferriere-mysql-data \
  fferriere/mysql-server
