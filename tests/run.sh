#!/bin/bash

set -euo pipefail

while read -r exe
do
	echo "[test] running $exe ..."
	$exe
done < <(find tests -name '*_test' -type f -executable)

