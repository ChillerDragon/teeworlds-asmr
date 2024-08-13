%include "tests/assert.asm"

_start:
    str_to_stack __FILE__
    mov r9, rax

    ; rax is pointer to 1st element in the array
    mov rax, huff_nodes
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, r9

    ; rax is pointer to 2nd element in the array
    mov rax, huff_nodes
    add rax, HUFF_CNODE_SIZE
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, r9

    ; rax is pointer to 3rd element in the array
    mov rax, huff_nodes
    add rax, HUFF_CNODE_SIZE
    add rax, HUFF_CNODE_SIZE
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, r9

    ; rax is pointer to the last element in the array
    mov rax, HUFF_CNODE_SIZE
    imul rax, HUFFMAN_MAX_NODES
    add rax, huff_nodes
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, r9

    ; free stack str
    mov rsp, rbp

    exit 0

