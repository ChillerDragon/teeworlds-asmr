%include "tests/assert.asm"

_start:
    printlnf "hello %d world", 10
    printf "%d %d foo bar ", 777, -1
    printf "%d, %d, %d;", 1, 2, 3
    printf "%d, %d, %d, %d, %d, %d, %d, %d;", 1, 2, 3, 4, 5, 6, 7, 8
    printf "%d, %p, %d, %d, %d, %d, %d, %d;", 1, rsp, 3, 4, 5, 6, 7, 8

    mov rcx, 0
    printf "rcx=%d (should be zero);", rcx

    mov rcx, 1
    printf "rcx=%d (should be one);", rcx

    printf "rsp=%p (should be ptr);", rsp

    printf "new\nline"

    exit 0
