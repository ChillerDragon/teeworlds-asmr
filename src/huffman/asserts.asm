%macro huff_assert_nodes_ptr 3
    ; huff_assert_nodes_ptr [ptr] [__LINE__] [__FILE__]
    push rax
    push rbp
    push rdi
    push r9

    ; crazy hack to store %1 on the stack
    ; before the stack allocated string
    ; and pop it back with a unknown stack offset
    mov rax, %1
    push rax
    mov r9, rsp

    str_to_stack %3
    mov rdi, rax ; rdi is ptr to file name str

    ; soft pop rax of the hacked stack
    mov rax, [r9]

    check_bounds rax, huff_nodes, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES, %2, rdi

    ; free stack str
    mov rsp, rbp

    ; free ptr hack
    pop rax

    pop r9
    pop rdi
    pop rbp
    pop rax
%endmacro

%macro huff_assert_decode_lut_ptr 3
    ; huff_assert_decode_lut_ptr [ptr] [__LINE__] [__FILE__]
    push rax
    push rbp
    push rdi
    push r9

    ; crazy hack to store %1 on the stack
    ; before the stack allocated string
    ; and pop it back with a unknown stack offset
    mov rax, %1
    push rax
    mov r9, rsp

    str_to_stack %3
    mov rdi, rax ; rdi is ptr to file name str

    ; soft pop rax of the hacked stack
    mov rax, [r9]

    check_bounds rax, huff_decode_lut, 8, HUFFMAN_LUTSIZE, %2, rdi

    ; free stack str
    mov rsp, rbp

    ; free ptr hack
    pop rax

    pop r9
    pop rdi
    pop rbp
    pop rax
%endmacro

%macro huff_assert_nodes_left_storage_ptr 3
    ; huff_assert_nodes_left_storage_ptr [ptr] [__LINE__] [__FILE__]
    push rax
    push rbp
    push rdi
    push r9

    ; crazy hack to store %1 on the stack
    ; before the stack allocated string
    ; and pop it back with a unknown stack offset
    mov rax, %1
    push rax
    mov r9, rsp

    str_to_stack %3
    mov rdi, rax ; rdi is ptr to file name str

    ; soft pop rax of the hacked stack
    mov rax, [r9]

    check_bounds rax, huff_nodes_left_storage, HUFF_CCONSTRUCTION_NODE_SIZE, HUFFMAN_MAX_SYMBOLS, %2, rdi

    ; free stack str
    mov rsp, rbp

    ; free ptr hack
    pop rax

    pop r9
    pop rdi
    pop rbp
    pop rax

%endmacro

%macro huff_assert_nodes_left_ptr 3
    ; huff_assert_nodes_left_ptr [ptr] [__LINE__] [__FILE__]
    push rax
    push rbp
    push rdi
    push r9

    ; crazy hack to store %1 on the stack
    ; before the stack allocated string
    ; and pop it back with a unknown stack offset
    mov rax, %1
    push rax
    mov r9, rsp

    str_to_stack %3
    mov rdi, rax ; rdi is ptr to file name str

    ; soft pop rax of the hacked stack
    mov rax, [r9]

    check_bounds rax, huff_nodes_left, 8, HUFFMAN_MAX_SYMBOLS, %2, rdi

    ; free stack str
    mov rsp, rbp

    ; free ptr hack
    pop rax

    pop r9
    pop rdi
    pop rbp
    pop rax
%endmacro

