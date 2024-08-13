%macro huff_assert_nodes_ptr 3
    ; huff_assert_nodes_ptr [ptr] [source line] [source file]
    push rax
    push rbp
    push rdi

    str_to_stack %3
    mov rdi, rax

    mov rax, %1
    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, %2, rdi

    mov rbp, rsp

    pop rdi
    pop rbp
    pop rax
%endmacro

%macro huff_assert_nodes_left_storage_ptr 3
    ; huff_assert_nodes_left_storage_ptr [ptr] [source line] [source file]
    push rax
    push rbp
    push rdi

    str_to_stack %3
    mov rdi, rax

    mov rax, %1
    check_bounds rax, huff_nodes_left_storage, HUFF_CCONSTRUCTION_NODE_SIZE, HUFFMAN_MAX_SYMBOLS, %2, rdi

    mov rbp, rsp

    pop rdi
    pop rbp
    pop rax
%endmacro

%macro huff_assert_nodes_left_ptr 3
    ; huff_assert_nodes_left_ptr [ptr] [source line] [source file]
    push rax
    push rbp
    push rdi

    str_to_stack %3
    mov rdi, rax

    mov rax, %1
    check_bounds rax, huff_nodes_left, 8, HUFFMAN_MAX_SYMBOLS, %2, rdi

    mov rbp, rsp

    pop rdi
    pop rbp
    pop rax
%endmacro

