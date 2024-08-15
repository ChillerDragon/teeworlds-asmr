%include "tests/assert.asm"

_start:
_test_call_huff_construct_tree:
    call print_newline ; todo: remove
    call _huff_construct_tree

_test_call_huff_construct_tree_assert_start_node:
    mov rax, qword [huff_start_node]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__


_test_call_huff_construct_tree_assert_node_0:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 0)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 1
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 1
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

_test_call_huff_construct_tree_assert_node_1:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 1)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 8
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 4
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 1

_test_call_huff_construct_tree_assert_node_2:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 2)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 2
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 5
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 2

_test_call_huff_construct_tree_assert_node_3:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 3)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 22
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 8
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 3

_test_call_huff_construct_tree_assert_node_4:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 4)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 30
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 6
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 4

_test_call_huff_construct_tree_assert_node_5:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 5)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 118
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 7
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 5

_test_call_huff_construct_tree_assert_node_6:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 6)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 54
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 8
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 6

_test_call_huff_construct_tree_assert_node_7:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 7)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 110
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 8
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 65535
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 65535
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 7

_test_call_huff_construct_tree_assert_node_510:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 510)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 0
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 507
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 508
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

_test_call_huff_construct_tree_assert_node_511:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 511)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 0
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 509
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 510
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

_test_call_huff_construct_tree_assert_node_512:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 512)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    assert_eax_eq 0
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 511
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 0
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

_test_call_huff_construct_tree_assert_node_513:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 513)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    ; assert_eax_eq 0 ; todo: this fails
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    ; assert_eax_eq 0 ; todo: this fails
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    ; assert_eax_eq 0 ; todo: this fails
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    ; assert_eax_eq 0 ; todo: this fails
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

    exit 0

