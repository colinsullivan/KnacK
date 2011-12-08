#! /usr/bin/env bash

# List paths to all chuck files relative to current directory
find ./* -name "*.ck" -not -name "include.ck" | \

# Wrap the paths in `Machine.add` and add to include.ck
perl -p -i -e 's/^\.\/(.*)$/Machine\.add("$1");/' #> include.ck