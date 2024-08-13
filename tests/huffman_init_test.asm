%include "tests/assert.asm"

_start:
    call huff_init


    lea rax, [huff_decode_lut + 0]
    huff_assert_decode_lut_ptr rax, __LINE__, __FILE__

    mov rax, [rax]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__


    lea rax, [huff_decode_lut + 8]
    huff_assert_decode_lut_ptr rax, __LINE__, __FILE__

    mov rax, [rax]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__


    lea rax, [huff_decode_lut + 16]
    huff_assert_decode_lut_ptr rax, __LINE__, __FILE__

    mov rax, [rax]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__

    exit 0

