#!/bin/bash
# workaround for flutter test --watch // not supported right now
flutter test --coverage
watchman-make -p 'lib/**/*.dart' 'test/**/*.dart'  --run 'flutter test --coverage'
