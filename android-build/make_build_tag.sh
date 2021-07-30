#!/bin/bash

set -e
set -o pipefail

usage() {
    echo "Usage: `basename $0` -m 'MODULE' -c 'TASK'";
    exit 1;
}


while getopts 'c:m:' OPT; do
    case $OPT in
        m)
            MODULE="$OPTARG";;
        c)
            TASK="$OPTARG";;
        *)
            usage;;
    esac
done

echo $TASK

if [ -z $MODULE ]; then
  echo 'Need pass module, like app, kaylee'
  exit 0
fi

if [ -z $TASK ]; then
  echo 'Need pass task, like assembleGoogleBeta'
  exit 0
fi

# echo "build-$MODULE-$TASK-`date -u +%Y%m%d%H%M%S`"
git tag "build-$MODULE-$TASK-`date -u +%Y%m%d%H%M%S`"
git push --tag
