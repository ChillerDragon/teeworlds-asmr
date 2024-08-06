; ; m_aNodes array of CNODE structs
; huff_nodes resb HUFF_CNODE_SIZE * HUFFMAN_MAX_NODES
; 
; ; m_apDecodeLut array of CNODE structs
; huff_decode_lut resb HUFFMAN_LUTSIZE * 8
; 
; ; pointer to start node
; huff_start_node resb 8
; 
; ; integer with amount of nodes
; huff_num_nodes resb 4

_huff_setbits_r_dbg_print_args:
    call print_newline

    print_label s_huff_set_bits
    call print_ptr
    call print_comma
    call print_space

    push rax
    print_label s_huff_bits_eq
    mov rax, rdi
    call print_int32

    call print_comma
    call print_space

    print_label s_huff_depth_eq
    mov rax, rsi
    call print_uint32
    pop rax

    call print_close_paren

    call print_newline

    print_label s_huff_node_colon
    call huff_print_struct_cnode
    call print_newline
    ret

_huff_setbits_r:
    ; _huff_setbits_r [rax] [rdi] [rsi]
    ;  rax = *pNode
    ;  rdi = int Bits
    ;  rsi = unsigned Depth
    push_registers
    call _huff_setbits_r_dbg_print_args

    ; leaf1
    push rdi
    push rsi

    mov rcx, 0
    mov word cx, [rax + HUFF_CNODE_LEAF_1_OFFSET]
    cmp cx, 0xffff
    je ._huff_setbits_r_no_leaf1_recursion

    ; &m_aNodes[pNode->m_aLeafs[1]]
    mov rbx, rcx
    imul rbx, HUFF_CNODE_SIZE
    lea rax, [huff_nodes + rbx]

    ; bits | (1<<Depth)
    mov r9, 1
    shift_left r9, rsi
    xor rdi, r9
    shl edx, cl

    ; depth + 1
    inc rsi
    call _huff_setbits_r

    pop rsi
    pop rdi

._huff_setbits_r_no_leaf1_recursion:

    ; leaf0
    mov word cx, [rax + HUFF_CNODE_LEAF_0_OFFSET]
    cmp cx, 0xffff
    je ._huff_setbits_r_no_leaf0_recursion

    ; &m_aNodes[pNode->m_aLeafs[0]]
    mov rbx, rcx
    imul rbx, HUFF_CNODE_SIZE
    lea rax, [huff_nodes + rbx]

    ; bits are still in rdi

    ; depth + 1
    inc rsi
    call _huff_setbits_r

._huff_setbits_r_no_leaf0_recursion:

    ; num bits
    mov dword ecx, [rax + HUFF_CNODE_LEAF_0_OFFSET]
    je ._huff_setbits_r_got_num_bits
    jmp ._huff_setbits_r_end

._huff_setbits_r_got_num_bits:
    ; node.bits = bits
    lea rcx, [rax + HUFF_CNODE_BITS_OFFSET]
    mov dword [rcx], edi

    ; node.num_bits = depth
    lea rcx, [rax + HUFF_CNODE_NUM_BITS_OFFSET]
    mov dword [rcx], esi

._huff_setbits_r_end:

    pop_registers
    ret

%macro huff_setbits_r 3
    ; huff_setbits_r [*pNode] [int Bits] [unsigned Depth]
    push rax
    push rdi
    push rsi

    mov rbp, rsp

    ; *pNode = 8 byte
    ; int Bits = 4 byte
    ; unsigned Depth = 4 byte
    ; 8 + 4 + 4 = 16
    sub rsp, 16

    mov qword [rbp-16], %1
    mov dword [rbp-8], %2
    mov dword [rbp-4], %3

    mov rax, [rbp-16]
    mov rdi, [rbp-8]
    mov rsi, [rbp-4]
    call _huff_setbits_r

    mov rsp, rbp

    pop rsi
    pop rdi
    pop rax
%endmacro

