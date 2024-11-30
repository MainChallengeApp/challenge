#!bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export $(cat $script_dir/../.env | xargs)