#!/bin/bash
set -xue

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ITERATIONS="5"
DATA_SIZE="100000000"
START_LEVEL="6"
END_LEVEL="6"
DATE=`date "+%Y-%m-%d"`
OUT_DIR="/tmp/deflate-$DATE"
JAVA_BIN="java"
JAVA_NAME="java"
INPUT_FILES=()
while (( "$#" )); do
  case "$1" in
    -i|--iterations)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ITERATIONS=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -d|--data-size)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        DATA_SIZE=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -j|--java-bin)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        JAVA_BIN=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -n|--java-name)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        JAVA_NAME=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -o|--output-dir)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OUT_DIR=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      INPUT_FILES+=("$( cd "$( dirname "$1" )" >/dev/null 2>&1 && pwd )"/`basename $1`)
      shift
      ;;
  esac
done

mkdir -p $OUT_DIR
pushd $OUT_DIR
echo "Changing to $OUT_DIR"
echo "Running benchmarks from $MYDIR"

declare -A JAVA_OPTS

# JAVA_OPTS["system"]="-XX:ZlibImplementation=system -XX:ZlibImplementationInflate=system -XX:ZlibImplementationDeflate=system"
JAVA_OPTS["bundled"]=""
JAVA_OPTS["chromium"]="-XX:ZlibImplementation=chromium -XX:ZlibImplementationInflate=chromium -XX:ZlibImplementationDeflate=chromium"
JAVA_OPTS["cloudflare"]="-XX:ZlibImplementation=cloudflare -XX:ZlibImplementationInflate=cloudflare -XX:ZlibImplementationDeflate=cloudflare"

for file in "${INPUT_FILES[@]}"; do
  for impl in "${!JAVA_OPTS[@]}"; do
    bash -c "$JAVA_BIN -cp $MYDIR/../../build/benchmarks \
             -Xms1G -Xmx1G -XX:+UseSerialGC -XX:+AlwaysPreTouch ${JAVA_OPTS[$impl]} \
             io.simonis.ZBench -n $ITERATIONS -i -c $START_LEVEL -c $END_LEVEL -p $DATA_SIZE \
             -j $JAVA_NAME-$impl -a $file -z $file.zlib -b /tmp/`basename $file`.zlib"
  done
done

popd
