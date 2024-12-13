on_chat:
    ; on_chat [rax]
    push_registers

    ; mode
    call get_int

    ; client id
    call get_int
    mov r8, rax

    ; target id
    call get_int
    mov r9, rax

    ; message
    call get_string
    mov r10, rax

    ; r12 is offset into chat_message_buffer_2048
    mov r12, 0

    ; check srv msg
    cmp r8w, -1
    jne .human_msg

    .server_msg:
    mov byte [chat_message_buffer_2048+r12], '*'
    inc r12
    mov byte [chat_message_buffer_2048+r12], '*'
    inc r12
    mov byte [chat_message_buffer_2048+r12], '*'
    inc r12
    mov byte [chat_message_buffer_2048+r12], ' '
    inc r12
    jmp .message_content

    .human_msg:
    ; get author name
    mov rbx, r8
    imul rbx, TW_CLIENT_SIZE
    lea rax, [chat_message_buffer_2048+r12] ; append buffer dst
    lea rdi, [tw_clients + rbx + TW_CLIENT_NAME_OFFSET] ; name append src
    mov rsi, 32 ; use max name length here or something
    call str_copy ; append name to buffer
    add r12, rax ; increment buffer offset by name length

    .message_content:
    mov byte [chat_message_buffer_2048+r12], ':'
    inc r12
    mov byte [chat_message_buffer_2048+r12], ' '
    inc r12

    lea rax, [chat_message_buffer_2048+r12]
    mov rdi, r10 ; chat message
    mov rsi, 1024 ; random max msg length xd
    call str_copy

    ; print message
    mov rax, c_chat
    mov rdi, chat_message_buffer_2048
    call log_info

    pop_registers
    ret

