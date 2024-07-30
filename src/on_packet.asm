on_system_or_game_messages:
    ; on_system_or_game_messages [rax] [rdi] [rsi]
    ;  rax = payload buffer
    ;  rdi = payload size in bytes
    ;  rsi = chunk callback
    ;         rax = chunk data buffer
    ;         for all other details check the chunk_header_* labels
    ;
    ; this method takes the entire packet payload as argument
    ; and reads all the chunk headers
    ; calling the given callback for all the found chunks (messages)
    push_registers

    ; payload buffer
    mov r9, rax

    ; payload size
    mov r10, rdi

    ; chunk callback
    mov r11, rsi

    ; print num chunks
    print s_got_packet_with_chunks
    mov rax, 0
    mov al, [packet_header_num_chunks]
    call print_uint32

    ; rcx is the offset in bytes pointer
    mov rcx, 0

    ; rbx amount of chunks found
    mov rbx, 0

.on_system_or_game_messages_chunk_split_loop:
    lea rax, [r9+rcx]
    call unpack_chunk_header
    call print_chunk_header

    ; count num chunks
    inc rbx

    ; base header size 2 bytes
    add rcx, 2
    ; plus big header size if vital
    is_chunk_flag CHUNKFLAG_VITAL
    jne .on_system_or_game_messages_chunk_non_vital_skip
    inc rcx
.on_system_or_game_messages_chunk_non_vital_skip:

    ; user callback
    lea rax, [r9+rcx]
    call r11

    ; plus payload size
    mov eax, [chunk_header_size]
    add ecx, eax

    ; break checks

    ; check got all expected chunks
    mov rax, 0
    mov byte al, [packet_header_num_chunks]
    cmp eax, ebx
    je .on_system_or_game_messages_loop_end

    ; check no space left
    ; bytes red (eax)
    mov rax, rcx
    add rax, 2 ; minimum length of next chunk
    ; bytes available (edx)
    mov rdx, r10
    ; eax (offset red) > r10d (packet len)
    cmp eax, r10d
    jg .on_system_or_game_messages_loop_error_end_of_data


    jmp .on_system_or_game_messages_chunk_split_loop

.on_system_or_game_messages_loop_error_end_of_data:
    ; rax is offset
    print s_parser_bytes_red
    call print_uint32

    ; r10 is payload size
    print s_received_bytes
    mov rax, r10
    call print_uint32

    print s_got_end_of_packet_with_chunks_left
    mov rax, 0
    mov byte al, [packet_header_num_chunks]
    sub al, bl
    call print_uint32
    exit 1

.on_system_or_game_messages_loop_end:

    pop_registers
    ret

on_game_message:
    ; on_game_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    print s_got_system_msg_with_id
    call print_uint32
    call print_newline
    ret

on_system_message:
    ; on_system_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    print s_got_game_msg_with_id
    call print_uint32
    call print_newline
    ret

on_message:
    ; on_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = system (CHUNK_SYSTEM or CHUNK_GAME)
    ;  rsi = message payload
    ;
    ; for size and flags check the chunk_header_* labels
    push_registers

    cmp edi, CHUNK_SYSTEM
    je .on_message_system

    jmp .on_message_game

.on_message_system:
    call on_system_message
    jmp .on_message_end

.on_message_game:
    call on_game_message

.on_message_end:
    pop_registers
    ret

on_packet:
    push rax
    mov rax, udp_recv_buf
    call unpack_packet_header
    pop rax

    is_packet_flag PACKETFLAG_CONTROL
    je on_ctrl_message

    mov rax, packet_payload
    mov rdi, [udp_read_len]
    sub rdi, PACKET_HEADER_LEN
    mov rsi, on_message
    call on_system_or_game_messages

on_packet_end:
    ret

