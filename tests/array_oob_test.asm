%include "tests/assert.asm"

_start:
    init_test __FILE__

    ; rax is pointer to 1st element in the array
    mov rax, huff_nodes
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, assert_test_filename

    ; rax is pointer to 2nd element in the array
    mov rax, huff_nodes
    add rax, HUFF_CNODE_SIZE
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, assert_test_filename

    ; rax is pointer to 3rd element in the array
    mov rax, huff_nodes
    add rax, HUFF_CNODE_SIZE
    add rax, HUFF_CNODE_SIZE
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, assert_test_filename

    ; rax is pointer to the last element in the array
    mov rax, HUFFMAN_MAX_NODES
    dec rax ; array[array.length - 1]
    imul rax, HUFF_CNODE_SIZE
    add rax, huff_nodes
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, assert_test_filename

    ; ; array[length] is out of bounds
    ; mov rax, HUFFMAN_MAX_NODES
    ; imul rax, HUFF_CNODE_SIZE
    ; add rax, huff_nodes
    ; check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, __LINE__, assert_test_filename

    end_test __LINE__
