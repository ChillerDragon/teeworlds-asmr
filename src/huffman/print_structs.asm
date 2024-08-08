; struct CNode
; {
; 	unsigned m_Bits;
; 	unsigned m_NumBits;
;
; 	unsigned short m_aLeafs[2];
;
; 	unsigned char m_Symbol;
; }

; HUFF_CNODE_BITS_OFFSET equ 0
; HUFF_CNODE_NUM_BITS_OFFSET equ 4
; HUFF_CNODE_LEAF_0_OFFSET equ 8
; HUFF_CNODE_LEAF_1_OFFSET equ 10
; HUFF_CNODE_SYMBOL_OFFSET equ 12
; HUFF_CNODE_SIZE equ 13

_huff_print_field_symbol:
    push rax
    push rbp
    mov rbp, rsp
    sub rsp, 24
    mov dword [rbp-24], 'Symb'
    mov dword [rbp-20], 'ol: '
    mov byte [rbp-16], 0
    lea rax, [rbp-24]
    print_c_str rax
    mov rsp, rbp
    pop rbp
    pop rax
    ret

_huff_print_field_leafs:
    push rax
    push rbp
    mov rbp, rsp
    sub rsp, 24
    mov dword [rbp-24], 'Leaf'
    mov word [rbp-20], 's:'
    mov word [rbp-18], 0x0020
    lea rax, [rbp-24]
    print_c_str rax
    mov rsp, rbp
    pop rbp
    pop rax
    ret

_huff_print_field_num_bits:
    push rax
    push rbp
    mov rbp, rsp
    sub rsp, 24
    mov dword [rbp-24], 'NumB'
    mov dword [rbp-20], 'its:'
    mov byte [rbp-16], ' '
    mov byte [rbp-15], 0
    lea rax, [rbp-24]
    print_c_str rax
    mov rsp, rbp
    pop rbp
    pop rax
    ret

_huff_print_field_bits:
    push rax
    push rbp
    mov rbp, rsp
    sub rsp, 20
    mov dword [rbp-20], 'bits'
    mov word [rbp-16], ': '
    mov byte [rbp-14], 0
    lea rax, [rbp-20]
    print_c_str rax
    mov rsp, rbp
    pop rbp
    pop rax
    ret

huff_print_struct_cnode:
    ; huff_print_struct_cnode [rax]
    ;  rax = pointer to cnode struct
    push_registers
    ; pointer to struct
    mov rsi, rax

    call print_open_curly

    call _huff_print_field_bits
    mov rax, 0
    mov eax, [rsi+HUFF_CNODE_BITS_OFFSET]
    call print_int32
    call print_comma
    call print_space

    call _huff_print_field_num_bits
    mov rax, 0
    mov eax, [rsi+HUFF_CNODE_NUM_BITS_OFFSET]
    call print_int32
    call print_comma
    call print_space

    call _huff_print_field_leafs
    call print_open_bracket
    mov rax, 0
    mov ax, [rsi+HUFF_CNODE_LEAF_0_OFFSET]
    call print_int32
    call print_comma
    call print_space
    mov rax, 0
    mov ax, [rsi+HUFF_CNODE_LEAF_1_OFFSET]
    call print_int32
    call print_close_bracket
    call print_comma
    call print_space

    call _huff_print_field_symbol
    mov rax, 0
    mov al, [rsi+HUFF_CNODE_SYMBOL_OFFSET]
    call print_uint32

    call print_close_curly

    pop_registers
    ret

huff_print_struct_cconstruction_node:
    ; huff_print_struct_cconstruction_node [rax]
    ;  rax = pointer to cconstruction_node struct
    push_registers
    ; pointer to struct
    mov rsi, rax

    call print_open_curly

    print "NodeId: "
    mov rax, 0
    mov eax, [rsi+HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET]
    call print_int32
    call print_comma
    call print_space

    print "Frequency: "
    mov rax, 0
    mov eax, [rsi+HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET]
    call print_int32

    call print_close_curly

    pop_registers
    ret

huff_print_construction_node_pointer:
    ; huff_print_construction_node_pointer [rax]
    ;  rax = pointer to pointer to construction node
    push_registers

    ; **ppConstructionNode -> *pConstructionNode
    mov r8, [rax]
    mov rax, r8

    print "ptr="
    call print_ptr
    print " -> "

    call huff_print_struct_cconstruction_node

    pop_registers
    ret

huff_print_arr_nodes_left:
    ; print huff_nodes_left
    ; which is an array of pointers to construction nodes
    print_struct_array huff_nodes_left, huff_print_construction_node_pointer, 8, 8 * HUFFMAN_MAX_SYMBOLS
    ret

huff_print_arr_nodes:
    ; print_struct_array [array buffer] [element_print_callback] [element size] [array size]
    print_struct_array huff_nodes, huff_print_struct_cnode, HUFF_CNODE_SIZE, HUFFMAN_MAX_NODES
    ret

