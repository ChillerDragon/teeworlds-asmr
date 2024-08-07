%include "tests/assert.asm"

_start:
    printf "hello %d world", 10
    printf "%d %d foo bar", 777, -1
    exit 0
