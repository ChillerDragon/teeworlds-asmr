#!/bin/bash

set -euo pipefail

while read -r exe
do
	printf '[test] running %s ' "$exe"
	$exe
	printf '\n'
done < <(find tests -name '*_test' -type f -executable)
