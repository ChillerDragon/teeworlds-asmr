%include "tests/assert.asm"

_start:
    call _huff_construct_tree
    exit 0

