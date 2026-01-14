#!/bin/bash

# Test script for Flutter project
# Exit codes:
#   0 - All tests passed
#   1 - Tests failed

echo "Running flutter test..."
if ! flutter test; then
    echo "flutter test failed"
    exit 1
fi

echo "All tests passed"
exit 0
