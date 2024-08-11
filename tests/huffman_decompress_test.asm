%include "tests/assert.asm"

_start:
    call print_newline
    call _huff_construct_tree
    exit 0

