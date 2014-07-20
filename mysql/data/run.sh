#!/bin/bash

NAME='fferriere-mysql-data'

docker run -d \
  --name $NAME \
  fferriere/mysql-data
