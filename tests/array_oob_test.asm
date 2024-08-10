%include "tests/assert.asm"

_start:
    ; rax is pointer to 2nd element in the array
    mov rax, huff_nodes
    add rax, HUFF_CNODE_SIZE
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES
    exit 0

