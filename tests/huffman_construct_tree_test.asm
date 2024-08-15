%include "tests/assert.asm"

%macro test_assert_node 12
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * %2)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq %4, __LINE__
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq %6, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq %8, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq %10, __LINE__
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq %12, __LINE__
%endmacro

_start:
    init_test __FILE__

_test_call_huff_construct_tree:
    call print_newline ; todo: remove
    call _huff_construct_tree

_test_call_huff_construct_tree_assert_start_node:
    mov rax, qword [huff_start_node]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__


    ; 0-19 (beginning of array)


_test_call_huff_construct_tree_assert_node_0:
    test_assert_node i, 0, bits, 1, num_bits, 1, leaf0, 65535, leaf1, 65535, symbol, 0

_test_call_huff_construct_tree_assert_node_1:
    test_assert_node i, 1, bits, 8, num_bits, 4, leaf0, 65535, leaf1, 65535, symbol, 1

_test_call_huff_construct_tree_assert_node_2:
    test_assert_node i, 2, bits, 2, num_bits, 5, leaf0, 65535, leaf1, 65535, symbol, 2

_test_call_huff_construct_tree_assert_node_3:
    test_assert_node i, 3, bits, 22, num_bits, 8, leaf0, 65535, leaf1, 65535, symbol, 3

_test_call_huff_construct_tree_assert_node_4:
    test_assert_node i, 4, bits, 30, num_bits, 6, leaf0, 65535, leaf1, 65535, symbol, 4

_test_call_huff_construct_tree_assert_node_5:
    test_assert_node i, 5, bits, 118, num_bits, 7, leaf0, 65535, leaf1, 65535, symbol, 5

_test_call_huff_construct_tree_assert_node_6:
    test_assert_node i, 6, bits, 54, num_bits, 8, leaf0, 65535, leaf1, 65535, symbol, 6

_test_call_huff_construct_tree_assert_node_7:
    test_assert_node i, 7, bits, 110, num_bits, 8, leaf0, 65535, leaf1, 65535, symbol, 7

_test_call_huff_construct_tree_assert_node_8:
    test_assert_node i, 8, bits, 4, num_bits, 5, leaf0, 65535, leaf1, 65535, symbol, 8

_test_call_huff_construct_tree_assert_node_9:
    test_assert_node i, 9, bits, 76, num_bits, 7, leaf0, 65535, leaf1, 65535, symbol, 9

_test_call_huff_construct_tree_assert_node_10:
    test_assert_node i, 10, bits, 122, num_bits, 7, leaf0, 65535, leaf1, 65535, symbol, 10

_test_call_huff_construct_tree_assert_node_11:
    test_assert_node i, 11, bits, 254, num_bits, 8, leaf0, 65535, leaf1, 65535, symbol, 11

_test_call_huff_construct_tree_assert_node_12:
    test_assert_node i, 12, bits, 114, num_bits, 7, leaf0, 65535, leaf1, 65535, symbol, 12

_test_call_huff_construct_tree_assert_node_13:
    test_assert_node i, 13, bits, 14, num_bits, 6, leaf0, 65535, leaf1, 65535, symbol, 13

_test_call_huff_construct_tree_assert_node_14:
    test_assert_node i, 14, bits, 244, num_bits, 8, leaf0, 65535, leaf1, 65535, symbol, 14

_test_call_huff_construct_tree_assert_node_15:
    test_assert_node i, 15, bits, 238, num_bits, 9, leaf0, 65535, leaf1, 65535, symbol, 15

_test_call_huff_construct_tree_assert_node_16:
    test_assert_node i, 16, bits, 106, num_bits, 7, leaf0, 65535, leaf1, 65535, symbol, 16

_test_call_huff_construct_tree_assert_node_17:
    test_assert_node i, 17, bits, 166, num_bits, 9, leaf0, 65535, leaf1, 65535, symbol, 17

_test_call_huff_construct_tree_assert_node_18:
    test_assert_node i, 18, bits, 92, num_bits, 7, leaf0, 65535, leaf1, 65535, symbol, 18

_test_call_huff_construct_tree_assert_node_19:
    test_assert_node i, 19, bits, 170, num_bits, 9, leaf0, 65535, leaf1, 65535, symbol, 19


    ; 255-257 (257 and onwards are different because they are not set in the symbol loop anymore)


_test_call_huff_construct_tree_assert_node_255:
    test_assert_node i, 255, bits, 146, num_bits, 8, leaf0, 65535, leaf1, 65535, symbol, 255

_test_call_huff_construct_tree_assert_node_256:
    test_assert_node i, 256, bits, 7050, num_bits, 15, leaf0, 65535, leaf1, 65535, symbol, 0

_test_call_huff_construct_tree_assert_node_257:
    test_assert_node i, 257, bits, 0, num_bits, 0, leaf0, 256, leaf1, 119, symbol, 0


    ; 510-513 (last nodes in array)


_test_call_huff_construct_tree_assert_node_510:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 510)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0, __LINE__
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 0, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 507, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 508, __LINE__
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0, __LINE__

_test_call_huff_construct_tree_assert_node_511:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 511)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0, __LINE__
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 0, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 509, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 510, __LINE__
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0, __LINE__

_test_call_huff_construct_tree_assert_node_512:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 512)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0, __LINE__
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 0, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 511, __LINE__
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 0, __LINE__
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0, __LINE__

    exit 0

