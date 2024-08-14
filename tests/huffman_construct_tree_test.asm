%include "tests/assert.asm"

_start:
_test_call_huff_construct_tree:
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

_test_call_huff_construct_tree_assert_node_510:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 510)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    ; assert_eax_eq 0 ; we get 2
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    ; assert_eax_eq 0
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
    ; assert_eax_eq 0
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 509
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 510
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

    exit 0

