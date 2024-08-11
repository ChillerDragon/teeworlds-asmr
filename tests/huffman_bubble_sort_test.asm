%include "tests/assert.asm"

%macro assert_node_id 2
    ; assert_freq [pointer to construction node] [expected node id]
    push rax
    push rsi
    push rbp

    mov rbp, rsp
    sub rsp, 12
    mov qword [rbp-12], %1
    mov word [rbp-4], %2

    mov rsi, [rbp-12]
    mov rax, 0
    mov ax, [rsi + HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET]

    mov r9, 0
    mov r9d, [rbp-4]

    assert_eax_eq r9d

    mov rsp, rbp

    pop rbp
    pop rsi
    pop rax
%endmacro

%macro assert_freq 2
    ; assert_freq [pointer to construction node] [expected frequency]
    push rax
    push rsi
    push rbp

    mov rbp, rsp
    sub rsp, 12
    mov qword [rbp-12], %1
    mov dword [rbp-4], %2

    mov rsi, [rbp-12]
    mov rax, 0
    mov eax, [rsi + HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET]

    mov r9, 0
    mov r9d, [rbp-4]

    assert_eax_eq r9d

    mov rsp, rbp

    pop rbp
    pop rsi
    pop rax
%endmacro

_start:
    call __huff_construct_tree_add_the_symbols

    ;  rax = **ppList
    mov rax, huff_nodes_left
    ;  rdi = Size
    mov rdi, HUFFMAN_MAX_SYMBOLS
    call _huff_bubble_sort

    mov rax, [huff_nodes_left]
    assert_freq rax, 1073741824
    ; printf "nodes[0]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left + 8]
    assert_freq rax, 4545
    ; printf "nodes[1]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline


    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-7)*8]
    assert_freq rax, 9
    ; printf "nodes[250]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-6)*8]
    assert_freq rax, 8
    assert_node_id rax, 118
    ; printf "nodes[251]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-5)*8]
    assert_freq rax, 8
    assert_node_id rax, 126
    ; printf "nodes[252]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-4)*8]
    assert_freq rax, 7
    ; printf "nodes[253]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-3)*8]
    assert_freq rax, 6
    ; printf "nodes[254]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-2)*8]
    assert_freq rax, 5
    ; printf "nodes[255]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    mov rax, [huff_nodes_left+(HUFFMAN_MAX_SYMBOLS-1)*8]
    assert_freq rax, 1
    ; printf "nodes[256]: "
    ; call huff_print_struct_cconstruction_node
    ; call print_newline

    exit 0

