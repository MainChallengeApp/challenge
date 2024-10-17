#!/bin/bash
# this script is used to select the firebase environment
# and needs to be executed before building the project
# it gets executed in xcode at Runner > Build Phases > Run Script

script_dir=$(dirname "$(realpath "$0")")

# load .env
export $(cat $script_dir/../.env | xargs)

# check if the environment is valid
if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "test" ] && [ "$ENVIRONMENT" != "prod" ]; then
  echo "Invalid environment. Please set the ENVIRONMENT to either 'dev', 'test' or 'prod'"
  exit 1
fi

cp $script_dir/../ios/Runner/GoogleService-Info_$ENVIRONMENT.plist $script_dir/../ios/Runner/GoogleService-Info.plist

