#!bin/bash

script_dir=$(dirname "$(realpath "$0")")
export $(cat $script_dir/../.env | xargs)