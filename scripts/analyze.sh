#!/bin/bash

# Static analysis script for Flutter project
# Exit codes:
#   0 - Analysis passed
#   1 - Analysis failed (info/warning/error found)

echo "Running flutter analyze..."
if ! flutter analyze --fatal-infos; then
    echo "flutter analyze failed"
    exit 1
fi

echo "Analysis passed"
exit 0
