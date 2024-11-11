#!/bin/bash
# workaround for flutter test --watch // not supported right now
clear
flutter test --coverage
watchman-make -p 'lib/**/*.dart' 'test/**/*.dart' --run 'clear && flutter test --coverage'
