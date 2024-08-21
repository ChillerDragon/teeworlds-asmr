%define S_DST_START 48
%define S_DST_END 40
%define S_SRC_END 32
%define S_BITS 24
%define S_BITCOUNT 20
%define S_EOF 16
%define S_NODE 8

%macro huff_set_node_decode_lut_bits_lutmask 0
    ; pNode = m_apDecodeLut[Bits&HUFFMAN_LUTMASK];
    mov rbx, 0
    mov ebx, dword [rbp-S_BITS]
    and ebx, HUFFMAN_LUTMASK
    imul rbx, 8
    mov r9, [huff_decode_lut + rbx]
    mov qword [rbp-S_NODE], r9
%endmacro

huff_decompress:
    ; huff_decompress [rax] [rdi] [rsi] [rdx]
    ;  rax = input
    ;  rdi = input size in bytes
    ;  rsi = output
    ;  rdx = output size in bytes
    ; returns into rax the decompressed size
    push_registers_keep_rax

    ; init can be called multiple times
    ; and it only does stuff once
    call huff_init

    mov rbp, rsp
    sub rsp, S_DST_START

    ; not in C++ version backup of rsi to compute size
    ; in the end
    mov qword [rbp-S_DST_START], rsi
    ; unsigned char *pDstEnd = nullptr
    mov qword [rbp-S_DST_END], 0
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

    ; pDstEnd = pDst + OutputSize
    mov r9, rsi
    add r9, rdx
    mov qword [rbp-S_DST_END], r9

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
    ; {A} try to load a node now, this will reduce dependency at location {D}
    ; pNode = nullptr
    mov qword [rbp-S_NODE], 0

    cmp dword [rbp-S_BITCOUNT], HUFFMAN_LUTBITS
    jl .huff_decompress_skip_node_set
    .huff_decompress_set_node:
    ; pNode = m_apDecodeLut[Bits&HUFFMAN_LUTMASK];
    huff_set_node_decode_lut_bits_lutmask
    .huff_decompress_skip_node_set:

    .huff_decompress_fill_while:
    cmp dword [rbp-S_BITCOUNT], 24
    jge .huff_decompress_fill_while_end
    cmp qword [rbp-S_SRC_END], rax
    je .huff_decompress_fill_while_end

    ; Bits |= (*pSrc++) << Bitcount;
    mov r9, 0
    mov r9b, byte [rax]
    mov r8, 0
    mov r8d, dword [rbp-S_BITCOUNT]
    shift_left r9, r8
    ; r9 = (*pSrc++) << Bitcount;
    mov r8, 0
    mov r8d, dword [rbp-S_BITS]
    or r8, r9
    mov dword [rbp-S_BITS], r8d
    ; pSrc++
    inc rax

    add dword [rbp-S_BITCOUNT], 8
    jmp .huff_decompress_fill_while
    .huff_decompress_fill_while_end:

    ; {C} load symbol now if we didn't that earlier at location {A}
    cmp qword [rbp-S_NODE], 0
    jne .huff_decompress_c_skip_set_node
    .huff_decompress_c_set_node:
    ; pNode = m_apDecodeLut[Bits&HUFFMAN_LUTMASK];
    huff_set_node_decode_lut_bits_lutmask
    .huff_decompress_c_skip_set_node:

    cmp qword [rbp-S_NODE], 0
    je .huff_decompress_error_c_no_node

    ; {D} check if we hit a symbol already
    mov r10, qword [rbp-S_NODE]
    huff_assert_nodes_ptr r10, __LINE__, __FILE__
    mov r8, 0
    mov r8d, dword [r10 + HUFF_CNODE_NUM_BITS_OFFSET]
    cmp r8d, 0
    je .huff_decompress_remove_the_bits_that_the_lut_checked_up_for_us
    .huff_decompress_remove_the_bits_for_that_symbol:
        ; Bits >>= pNode->m_NumBits;
        mov r9, 0
        mov r9d, dword [rbp-S_BITS]
        ; r8 is still num bits
        shift_right r9, r8
        mov dword [rbp-S_BITS], r9d

        ; Bitcount -= pNode->m_NumBits;
        mov r9, 0
        mov r9d, dword [rbp-S_BITCOUNT]
        sub r9, r8
        mov dword [rbp-S_BITCOUNT], r9d
    jmp .huff_decompress_check_for_eof
    ; } else {
    .huff_decompress_remove_the_bits_that_the_lut_checked_up_for_us:
        ; Bits >>= HUFFMAN_LUTBITS;
        mov r9, 0
        mov r9d, dword [rbp-S_BITS]
        shift_right r9, HUFFMAN_LUTBITS
        mov dword [rbp-S_BITS], r9d

        ; Bitcount -= HUFFMAN_LUTBITS;
        mov r9, 0
        mov r9d, dword [rbp-S_BITCOUNT]
        sub r9, HUFFMAN_LUTBITS
        mov dword [rbp-S_BITCOUNT], r9d

        ; walk the tree bit by bit
        .huff_decompress_walk_while:
            ; traverse tree
	    ; pNode = &m_aNodes[pNode->m_aLeafs[Bits&1]];
            mov r9, 0
            mov r9d, dword [rbp-S_BITS]
            and r9, 1
            imul r9, 2
            ; r9 [Bits&1]
            mov r8, qword [rbp-S_NODE]
            ; rbx is pNode->m_aLeafs[Bits&1]
            mov rbx, 0
            mov bx, [r8 + HUFF_CNODE_LEAF_0_OFFSET + r9]
            imul rbx, HUFF_CNODE_SIZE
            ; r8 = &m_aNodes[pNode->m_aLeafs[Bits&1]];
            lea r8, qword [huff_nodes + rbx]
            mov qword [rbp-S_NODE], r8

            ; remove bit
            mov r8, 0
            mov r8d, dword [rbp-S_BITCOUNT]
            dec r8
            mov dword [rbp-S_BITCOUNT], r8d

            mov r8d, dword [rbp-S_BITS]
            shr r8d, 1
            mov dword [rbp-S_BITS], r8d

            ; check if we hit a symbol
            ; r10=pNode and r8=numbits
            mov r10, qword [rbp-S_NODE]
            huff_assert_nodes_ptr r10, __LINE__, __FILE__
            mov r8, 0
            mov r8d, dword [r10 + HUFF_CNODE_NUM_BITS_OFFSET]
            cmp r8d, 0
            je .huff_decompress_hit_no_symbol
            .huff_decompress_hit_symbol:
                ; break
                jmp .huff_decompress_walk_while_end
            .huff_decompress_hit_no_symbol:

            ; no more bits, decoding error
            cmp dword [rbp-S_BITCOUNT], 0
            je .huff_decompress_error_no_more_bits
            jmp .huff_decompress_walk_while
        .huff_decompress_walk_while_end:
    ; } // end of outer if(pNode->m_NumBits) if statament
    .huff_decompress_check_for_eof:
    mov r8, qword [rbp-S_NODE]
    mov r9, qword [rbp-S_EOF]
    cmp r8, r9
    ; if(pNode == pEof) break
    je .huff_decompress_outer_while_end

    .huff_decompress_check_output_character:
    cmp rsi, qword [rbp-S_DST_END]
    je .huff_decompress_error_output_too_small

    .huff_decompress_write_symbol:
    ; r8 is still pNode
    mov r10b, byte [r8 + HUFF_CNODE_SYMBOL_OFFSET]
    mov byte [rsi], r10b
    ; pDst++
    inc rsi

    jmp .huff_decompress_outer_while
.huff_decompress_outer_while_end:

    jmp .huff_decompress_end
.huff_decompress_error_output_too_small:
    puts "[error] huffman output buffer too small"
    exit 1
.huff_decompress_error_c_no_node:
    puts "[error] huffman got node nullptr in {C} section"
    exit 1
.huff_decompress_error_no_more_bits:
    puts "[error] huffman no more bits"
    exit 1
.huff_decompress_end:
    mov rsp, rbp

    mov rax, qword [rbp-S_DST_START]
    sub rsi, rax
    mov rax, rsi

    pop_registers_keep_rax
    ret

%undef S_DST_START
%undef S_DST_END
%undef S_SRC_END
%undef S_BITS
%undef S_BITCOUNT
%undef S_EOF
%undef S_NODE

