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

; TODO: add assert to check if its called twice
;       calling construct tree twice is not supported yet
;       teeworlds calls it from the init method
;       which first zeros the member variables
;       we do not zero anything and depend on the bss section
;       doing the zeroing for us
;       which means its only zero on the first run
;       that is also fine because in the client we want to init the tree
;       on launch once and then use it for the entire runtime
;       but if this would twice in for example a test it would bug
_huff_construct_tree:
    push_registers
    mov rbp, rsp

    sub rsp, 4
    ; int NumNodesLeft = HUFFMAN_MAX_SYMBOLS
    mov dword [rbp-4], HUFFMAN_MAX_SYMBOLS

    mov rcx, 0
    ; for(int i = 0; i < HUFFMAN_MAX_SYMBOLS; i++)
._huff_construct_tree_for_loop:
    cmp rcx, HUFFMAN_MAX_SYMBOLS
    jge ._huff_construct_tree_for_loop_end

    mov rbx, rcx
    imul rbx, HUFF_CNODE_SIZE
    ; m_aNodes[i].m_NumBits = 0xFFFFFFFF;
    mov dword [huff_nodes + rbx + HUFF_CNODE_NUM_BITS_OFFSET], 0xFFFF_FFFF
    ; m_aNodes[i].m_Symbol = i;
    mov byte [huff_nodes + rbx + HUFF_CNODE_SYMBOL_OFFSET], cl
    mov word [huff_nodes + rbx + HUFF_CNODE_LEAF_0_OFFSET], 0xffff
    mov word [huff_nodes + rbx + HUFF_CNODE_LEAF_1_OFFSET], 0xffff

    ; get i offset into aNodesLeftStorage[i]
    mov rbx, rcx
    imul rbx, HUFF_CCONSTRUCTION_NODE_SIZE

    ; if(i == HUFFMAN_EOF_SYMBOL)
    cmp rcx, HUFFMAN_EOF_SYMBOL
    jne ._huff_construct_tree_i_not_eof
    mov dword [huff_nodes_left_storage + rbx + HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET], 1
    jmp ._huff_construct_tree_for_loop_if_end
._huff_construct_tree_i_not_eof:
    ; eax = pFrequencies[i]
    ; r9 = i
    mov r9, rcx
    ; 4 is the size of int / unsigned int
    ; which is the element size in the freq table array
    imul r9, 4
    mov rax, 0
    mov eax, [HUFF_FREQ_TABLE + r9]
    mov dword [huff_nodes_left_storage + rbx + HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET], eax
._huff_construct_tree_for_loop_if_end:

    ; aNodesLeftStorage[i].m_NodeId = i;
    ; rbx is still the correct [i] offset
    mov word [huff_nodes_left_storage + rbx + HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET], cx

    ; rax = &aNodesLeftStorage[i];
    lea rax, [huff_nodes_left_storage + rbx]

    mov rbx, rcx
    ; 8 is the size of a pointer on 64 bit machines
    ; huff_nodes_left is an array of pointers
    imul rbx, 8
    mov qword [huff_nodes_left + rbx], rax

    inc rcx
    jmp ._huff_construct_tree_for_loop
._huff_construct_tree_for_loop_end:

    ; m_NumNodes = HUFFMAN_MAX_SYMBOLS;
    mov dword [huff_num_nodes], HUFFMAN_MAX_SYMBOLS

    ; while(NumNodesLeft > 1)
._huff_construct_tree_while_loop:
    cmp dword [rbp-4], 1
    jle ._huff_construct_tree_while_loop_end

    ;  rax = **ppList
    mov rax, huff_nodes_left
    ;  rdi = Size
    ; rbp-4 is NumNodesLeft
    mov rdi, 0
    mov edi, [rbp-4]
    call _huff_bubble_sort

    ; m_aNodes[m_NumNodes].m_NumBits = 0;
    mov rbx, [rbp-4]
    imul rbx, HUFF_CNODE_SIZE
    mov dword [huff_nodes + rbx + HUFF_CNODE_NUM_BITS_OFFSET], 0

    ; r9 is the offset NumNodesLeft into apNodesLeft
    mov r9, 0
    mov r9d, [rbp-4]
    ; apNodesLeft is an array of pointers
    ; so the offset is 8 (pointer size)
    imul r9, 8

    ; m_aNodes[m_NumNodes].m_aLeafs[0] = apNodesLeft[NumNodesLeft-1]->m_NodeId;
    ; rax = apNodesLeft[NumNodesLeft-1]->m_NodeId;
    ;                 NumNodesLeft - 1
    mov rsi, [huff_nodes_left + r9 - (1 * 8)] ; get pointer from array
    ; get 2 byte field from struct at dereferenced value
    ; ax = unsigned int NodeId
    mov rax, 0
    mov ax, [rsi + HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET]
    mov word [huff_nodes + rbx + HUFF_CNODE_LEAF_0_OFFSET], ax

    ; m_aNodes[m_NumNodes].m_aLeafs[1] = apNodesLeft[NumNodesLeft-2]->m_NodeId;
    ; rax = apNodesLeft[NumNodesLeft-2]->m_NodeId;
    ;                 NumNodesLeft - 2
    mov rsi, [huff_nodes_left + r9 - (2 * 8)] ; get pointer from array
    ; get 2 byte field from struct at dereferenced value
    ; ax = unsigned int NodeId
    mov rax, 0
    mov ax, [rsi + HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET]
    mov word [huff_nodes + rbx + HUFF_CNODE_LEAF_1_OFFSET], ax

    ; apNodesLeft[NumNodesLeft-2]->m_NodeId = m_NumNodes;
    mov rax, [huff_nodes_left + r9 - (2 * 8)] ; get pointer from array
    add rax, HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET ; ->m_NodeId
    mov si, [huff_num_nodes]
    mov word [rax], si


    ; apNodesLeft[NumNodesLeft-2]->m_Frequency = apNodesLeft[NumNodesLeft-1]->m_Frequency + apNodesLeft[NumNodesLeft-2]->m_Frequency;

    ; r10 = apNodesLeft[NumNodesLeft-1]->m_Frequency
    ;                 NumNodesLeft - 1
    mov rax, [huff_nodes_left + r9 - (1 * 8)] ; get pointer from array
    ; get 4 byte field from struct at dereferenced value
    ; r10d = int m_Frequency
    mov r10, 0
    mov r10d, [rax + HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET]

    ; r11 = apNodesLeft[NumNodesLeft-2]->m_Frequency
    ;                 NumNodesLeft - 2
    mov rax, [huff_nodes_left + r9 - (2 * 8)] ; get pointer from array
    ; get 4 byte field from struct at dereferenced value
    ; r10d = int m_Frequency
    mov r11, 0
    mov r11d, [rax + HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET]

    ; apNodesLeft[NumNodesLeft-1]->m_Frequency + apNodesLeft[NumNodesLeft-2]->m_Frequency;
    add r10, r11

    ; apNodesLeft[NumNodesLeft-2]->m_Frequency = r10
    mov rax, [huff_nodes_left + r9 - (2 * 8)] ; get pointer from array
    add rax, HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET ; ->m_Frequency
    mov dword [rax], r10d

    ; m_NumNodes++
    mov rax, 0
    mov eax, [huff_num_nodes]
    inc eax
    mov [huff_num_nodes], eax

    ; NumNodesLeft--
    dec dword [rbp-4]

    jmp ._huff_construct_tree_while_loop
._huff_construct_tree_while_loop_end:

    ; ebx = m_NumNodes - 1
    mov rbx, 0
    mov ebx, [huff_num_nodes]
    dec ebx

    ; rax = &m_aNodes[m_NumNodes-1]
    imul ebx, HUFF_CNODE_SIZE
    lea rax, [huff_nodes + ebx]
    ; m_pStartNode = &m_aNodes[m_NumNodes-1];
    mov qword [huff_start_node], rax

    exit 0

    ;  rax = *pNode (still set)
    ;  rdi = int Bits
    mov rdi, 0
    ;  rsi = unsigned Depth
    mov rsi, 0
    call _huff_setbits_r


    mov rsp, rbp
    pop_registers
    ret

