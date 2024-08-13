%define S_SRC_END 32
%define S_BITS 24
%define S_BITCOUNT 20
%define S_EOF 16
%define S_NODE 8

huff_decompress:
    ; huff_decompress [rax] [rdi] [rsi] [rdx]
    ;  rax = input
    ;  rdi = input size in bytes
    ;  rsi = output
    ;  rdx = output size in bytes
    push_registers

    ; init can be called multiple times
    ; and it only does stuff once
    call huff_init

    mov rbp, rsp
    sub rsp, S_SRC_END

    ; unsigned char *pSrcEnd = nullptr
    mov qword [rbp-S_SRC_END], 0
    ; int Bits = 0
    mov dword [rbp-S_BITS], 0
    ; int Bitcount = 0
    mov dword [rbp-S_BITCOUNT], 0
    ; CNode *pEof = nullptr
    mov qword [rbp-S_EOF], 0
    ; CNode *pNode = nullptr
    mov qword [rbp-S_NODE], 0

    ; pSrcEnd = pSrc + InputSize
    mov r9, rax
    add r9, rdi
    mov qword [rbp-S_SRC_END], r9

    ; pEof = &m_aNodes[HUFFMAN_EOF_SYMBOL]
    mov rbx, HUFFMAN_EOF_SYMBOL
    imul rbx, HUFF_CNODE_SIZE
    lea r9, [huff_nodes + rbx]
    mov qword [rbp-S_EOF], r9

.huff_decompress_outer_while:
    ; pNode = nullptr
    mov qword [rbp-S_NODE], 0

    cmp dword [rbp-S_BITCOUNT], HUFFMAN_LUTBITS
    jl .huff_decompress_skip_node_set
    .huff_decompress_set_node:
    ; pNode = m_apDecodeLut[Bits&HUFFMAN_LUTMASK];
    mov rbx, 0
    mov ebx, dword [rbp-S_BITS]
    and ebx, HUFFMAN_LUTMASK
    imul rbx, 8
    mov r9, [huff_decode_lut + rbx]
    huff_assert_nodes_ptr r9, __LINE__, __FILE__
    mov qword [rbp-S_NODE], r9
    .huff_decompress_skip_node_set:

    .huff_decompress_fill_while:
    cmp dword [rbp-S_BITCOUNT], 24
    jge .huff_decompress_fill_while_end
    cmp qword [rbp-S_SRC_END], rax
    je .huff_decompress_fill_while_end

    ; Bits |= (*pSrc++) << Bitcount;


    .huff_decompress_fill_while_end:

    .huff_decompress_walk_while:
    .huff_decompress_walk_while_end:
.huff_decompress_outer_while_end:

    mov rsp, rbp

    pop_registers
    ret

%undef S_SRC_END
%undef S_BITS
%undef S_BITCOUNT
%undef S_EOF
%undef S_NODE

