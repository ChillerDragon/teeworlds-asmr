%define S_BITS 12
%define S_NODE 4

_huff_build_decode_lut:
    push_registers

    mov rbp, rsp
    sub rsp, S_BITS
    mov dword [rbp-S_BITS], 0
    mov qword [rbp-S_NODE], 0

    ; rcx is i in for loop
    mov rcx, 0
._huff_build_decode_lut_for_i:
    ; unsigned Bits = i;
    mov dword [rbp-S_BITS], ecx

    ; CNode *pNode = m_pStartNode;
    mov rax, [huff_start_node]
    mov qword [rbp-S_NODE], rax

    ; rdx = int k
    mov rdx, 0
._huff_build_decode_lut_for_k:
        ; pNode = &m_aNodes[pNode->m_aLeafs[Bits&1]];
        mov rax, 0
        mov eax, [rbp-S_BITS]
        ; rax = Bits&1
        and rax, 1

        ; m_aLeafs[Bits&1] array as branch hack
        ; rax is the index into m_aLeafs
        ; so it has to be multiplied with the element size
        ; which is 2 (unsigned short m_aLeafs[2];)
        imul rax, 2

        mov rsi, [rbp-S_NODE]

        ; rbx = pNode->m_aLeafs[Bits&1] (unsigned short)
        mov rbx, 0
        mov bx, [rsi + HUFF_CNODE_LEAF_0_OFFSET + rax]
        imul rbx, HUFF_CNODE_SIZE

        ; r9 = &m_aNodes[pNode->m_aLeafs[Bits&1]];
        lea r9, [huff_nodes + rbx]
        mov qword [rbp-S_NODE], r9


        ; Bits >>= 1;
        mov rax, 0
        mov eax, [rbp-S_BITS]
        shr eax, 1
        mov [rbp-S_BITS], eax

        ; C++ has a null pointer check for
        ; pNode here. While porting to go and python
        ; i realized that is not needed so yolo

        ; if(pNode->m_NumBits)
        mov rsi, [rbp-S_NODE]
        mov rax, 0
        mov eax, [rsi+HUFF_CNODE_NUM_BITS_OFFSET]
        cmp eax, 0
        je ._huff_build_decode_lut_check_for_k_repeat
        ._huff_build_decode_lut_got_num_bits:
            ; m_apDecodeLut[i] = pNode;
            mov rax, [rbp-S_NODE]
            mov rbx, rcx
            imul rbx, 8
            ; rbx = [i] into m_apDecodedLut
            lea rsi, [huff_decode_lut + rbx]
            mov [rsi], rax

            ; break
            jmp ._huff_build_decode_lut_for_k_end

        ._huff_build_decode_lut_check_for_k_repeat:
        ; k++
        inc rdx
        ; k < HUFFMAN_LUTBITS
        cmp rdx, HUFFMAN_LUTBITS
        jl ._huff_build_decode_lut_for_k
._huff_build_decode_lut_for_k_end:

    ; if(k == HUFFMAN_LUTBITS)
    cmp rdx, HUFFMAN_LUTBITS
    je ._huff_build_decode_lut_for_i_end

    ; i++
    inc rcx
    ; i < HUFFMAN_LUTSIZE
    cmp rcx, HUFFMAN_LUTSIZE
    jl ._huff_build_decode_lut_for_i
._huff_build_decode_lut_for_i_end:

    mov rsp, rbp

    pop_registers
    ret

%undef S_BITS
%undef S_NODE

