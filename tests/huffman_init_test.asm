%include "tests/assert.asm"

_start:
_test_huff_init:
    call huff_init


_test_huff_init_assert_decode_lut:
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

_test_huff_init_assert_eof_node:

    mov rbx, HUFFMAN_EOF_SYMBOL
    imul rbx, HUFF_CNODE_SIZE
    lea rsi, [huff_nodes + rbx]

    ; C++ prints this. So do we
    ; node: {bits: 7050, NumBits: 15, Leafs: [65535, 65535], Symbol: 0}
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 7050
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 15
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

    exit 0

