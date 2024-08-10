%macro huff_assert_nodes_ptr 1
    push rax
    mov rax, %1
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES
    pop rax
%endmacro

