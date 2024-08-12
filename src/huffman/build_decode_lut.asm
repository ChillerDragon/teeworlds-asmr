%define S_BITS 0
%define S_NODE 4
%define S_SIZE 12

_huff_build_decode_lut:
    push_registers

    mov rbp, rsp
    sub rsp, S_SIZE
    mov dword [rbp-S_BITS], 0
    mov qword [rbp-S_NODE], 0

    ; rcx is i in for loop
    mov rcx, 0
._huff_build_decode_lut_for_i:
    ; unsigned Bits = i;
    mov dword [rbp-S_BITS], ecx

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
%undef S_SIZE

