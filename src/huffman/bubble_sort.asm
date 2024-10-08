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

_huff_bubble_sort:
    ; _huff_bubble_sort [rax] [rdi]
    ;  rax = **ppList
    ;  rdi = Size
    push_registers
    mov rbp, rsp
    sub rsp, 28

    ; &ppList[i] = nullptr
    mov qword [rbp-28], 0

    ; &ppList[i+1] = nullptr
    mov qword [rbp-20], 0

    ; int Changed = 1
    mov dword [rbp-12], 1

    ; *pTemp = nullptr
    mov qword [rbp-8], 0

._huff_bubble_sort_while_changed:
    ; while(Changed)
    cmp dword [rbp-12], 0
    je ._huff_bubble_sort_while_changed_end

    ; Changed = 0
    mov dword [rbp-12], 0

    ; for(int i = 0; i < Size - 1; i++)
    mov rcx, 0 ; i = 0
    ; r9 = Size - 1
    mov r9, rdi
    dec r9
._huff_bubble_sort_for_i_less_size:
    ; i < Size-1
    cmp rcx, r9
    jge ._huff_bubble_sort_for_i_less_size_end

    ; if(ppList[i]->m_Frequency < ppList[i+1]->m_Frequency)
    ; i frequency
    mov rbx, rcx
    ; array of pointer offset
    imul rbx, 8
    ; ppList[i]
    ; r8 is pointer to the construction node
    mov r8, [rax + rbx]
    ; ppList[i]->m_Frequency
    mov r10, 0
    mov r10d, [r8 + HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET]
    ; ppList[i] =
    lea rsi, [rax + rbx]
    mov [rbp-28], rsi

    ; i+1 frequency
    mov rbx, rcx
    inc rbx
    ; array of pointer offset
    imul rbx, 8
    ; ppList[i+1]
    ; r8 is pointer to the construction node
    mov r8, [rax + rbx]
    ; ppList[i+1]->m_Frequency
    mov r11, 0
    mov r11d, [r8 + HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET]
    ; ppList[i+1] =
    lea rsi, [rax + rbx]
    mov [rbp-20], rsi

    inc rcx ; i++

    cmp r10d, r11d
    jge ._huff_bubble_sort_for_i_less_size

    ; if(ppList[i]->m_Frequency < ppList[i+1]->m_Frequency)
    ; is true

    push rax ; use rax in swap

    ; pTemp = ppList[i];
    ; rsi = &ppList[i]
    mov rsi, [rbp-28]
    ; rsi = ppList[i]
    mov rsi, [rsi]
    mov qword [rbp-8], rsi

    ; ppList[i] = ppList[i+1];
    ; rsi = &ppList[i+1]
    mov rsi, [rbp-20]
    ; rsi = ppList[i+1]
    mov rsi, [rsi]
    ; rax = ppList[i]
    mov rax, qword [rbp-28]
    mov [rax], rsi

    ; printlnf "rax=%p <- rsi=%p nodes_left_storage=%p nodes_left=%p", rax, rsi, huff_nodes_left_storage, huff_nodes_left

    ; ppList[i+1] = pTemp;
    ; rsi = pTemp
    mov rsi, [rbp-8]
    ; rax = ppList[i+1]
    mov rax, qword [rbp-20]
    mov [rax], rsi

    ; Changed = 1
    mov dword [rbp-12], 1

    pop rax ; use rax in swap

    jmp ._huff_bubble_sort_for_i_less_size
._huff_bubble_sort_for_i_less_size_end:
    ; Size--
    dec rdi
    jmp ._huff_bubble_sort_while_changed


._huff_bubble_sort_while_changed_end:

    mov rsp, rbp
    pop_registers
    ret

