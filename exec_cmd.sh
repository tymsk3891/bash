#!/bin/bash


function exec_cmd() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][LOG] start: $1"
  eval $1
  errcode=$?
  if [ $errcode -eq 0 ]; then
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][LOG][$errcode] $1 - line: $2"
    return 0
  else
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][ERROR][$errcode] $1 - line: $2" >&2
    exit 1
  fi
}


#cmd="echo hello!"
#exec_cmd "${cmd}" ${LINENO}
