%include "tests/assert.asm"

_start:
test_pack_chunk_header:
    mov dword [connection_sequence], 9

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 6
    mov rsi, assert_actual_buf
    call pack_chunk_header

    mov al, [assert_actual_buf]
    assert_al_eq 0x40
    mov al, [assert_actual_buf + 1]
    assert_al_eq 0x06
    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x09

    ; the chunk header packer should not increment the sequence number

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 6
    mov rsi, assert_actual_buf
    call pack_chunk_header


    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x09

test_pack_queue_chunk:
    packer_reset

    ; queue_chunk [rax] [rdi] [rsi] [rdx] [r10]
    ;  rax = flags (vital & resend)
    ;  rdi = payload
    ;  rsi = payload size
    ;  rdx = msg id
    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)

    mov dword [connection_sequence], 9

    ; rax: flags
    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL

    ; rdi: payload
    assert_input_buf_reset
    assert_input_buf_push_byte 0xAA
    assert_input_buf_push_byte 0xBB
    mov rdi, assert_input_buf

    ; rsi: payload size
    mov rsi, 2

    ; rdx: message id
    mov rdx, 2 ; todo maybe use an actual msg id constant here

    ; r10: system or game
    mov r10, CHUNK_GAME

    call queue_chunk

    ; asserts

    mov al, [udp_send_buf + PACKET_HEADER_LEN]
    assert_al_eq 0x40
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 1]
    assert_al_eq 0x02
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x0A

    ; call again to verify sequence incrementing
    packer_reset

    ; rax: flags
    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL

    call queue_chunk

    ; asserts
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x0B


    ; call again to verify sequence incrementing even more
    packer_reset

    ; rax: flags
    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL

    call queue_chunk

    ; asserts
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x0C

    exit 0
