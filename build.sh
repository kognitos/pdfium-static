#!/bin/bash -eu

OS_NAMES="linux|mac|win"
CPU_NAMES="arm64|x64"
STEP_REGEX="[0-9]|10"

START_STEP=0

if [[ $# == 0 ]]
then
  echo "PDFium build script.
https://github.com/kognitos/pdfium-static

Usage $0 [options] os cpu

Arguments:
   os       = Target OS ($OS_NAMES)
   cpu      = Target CPU ($CPU_NAMES)

Options:
  -b branch = Chromium branch (default=main)
  -g 0-10   = Go immediately to step n (default=0)
  -d        = debug build
  -s        = static build"
  exit
fi

while getopts "b:dsg:" OPTION
do
  case $OPTION in
    b)
      export PDFium_BRANCH="$OPTARG"
      ;;

    d)
      export PDFium_IS_DEBUG=true
      ;;

    s)
      export PDFium_BUILD_TYPE="static"
      ;;

    g)
      START_STEP="$OPTARG"
      ;;

    *)
      echo "Invalid flag -$OPTION"
      exit 1
  esac
done
shift $(($OPTIND -1))

if [[ $# -ne 2 ]]
then
  echo "You must specify target OS and CPU"
  exit 1
fi

if [[ ! $1 =~ ^($OS_NAMES)$ ]]
then
  echo "Unknown OS: $1"
  exit 1
fi

if [[ ! $2 =~ ^($CPU_NAMES)$ ]]
then
  echo "Unknown CPU: $2"
  exit 1
fi

if [[ ! $START_STEP =~ ^($STEP_REGEX)$ ]]
then
  echo "Invalid step number: $START_STEP"
  exit 1
fi

export PDFium_TARGET_OS=$1
export PDFium_TARGET_CPU=$2

set -x

ENV_FILE=${GITHUB_ENV:-.env}
PATH_FILE=${GITHUB_PATH:-.path}

[ $START_STEP -le 0 ] && . steps/00-environment.sh
source "$ENV_FILE"

[ $START_STEP -le 1 ] && . steps/01-install.sh
PATH="$(tr '\n' ':' < "$PATH_FILE")$PATH"
export PATH

[ $START_STEP -le 2 ] && . steps/02-checkout.sh
[ $START_STEP -le 3 ] && . steps/03-patch.sh
[ $START_STEP -le 4 ] && . steps/04-install-extras.sh
[ $START_STEP -le 5 ] && . steps/05-configure.sh
[ $START_STEP -le 6 ] && . steps/06-build.sh
[ $START_STEP -le 7 ] && . steps/07-stage.sh
[ $START_STEP -le 8 ] && . steps/08-licenses.sh
[ $START_STEP -le 9 ] && . steps/09-test.sh
[ $START_STEP -le 10 ] && . steps/10-pack.sh
