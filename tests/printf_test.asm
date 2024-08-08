%include "tests/assert.asm"

_start:
    printf "hello %d world", 10
    printf "%d %d foo bar", 777, -1

    mov rcx, 0
    printf "rcx=%d (should be zero)", rcx

    mov rcx, 1
    printf "rcx=%d (should be one)", rcx

    exit 0
