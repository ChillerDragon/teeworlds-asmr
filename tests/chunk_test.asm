%include "tests/assert.asm"

_start:
    init_test __FILE__

test_pack_chunk_header:
    mov dword [connection_sequence], 9

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 6
    mov rsi, assert_actual_buf
    call pack_chunk_header

    mov al, [assert_actual_buf]
    assert_al_eq 0x40, __LINE__
    mov al, [assert_actual_buf + 1]
    assert_al_eq 0x06, __LINE__
    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x09, __LINE__

    ; the chunk header packer should not increment the sequence number

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 6
    mov rsi, assert_actual_buf
    call pack_chunk_header


    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x09, __LINE__

test_pack_chunk_header_big_size:
    mov dword [connection_sequence], 3

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 69
    mov rsi, assert_actual_buf
    call pack_chunk_header

    mov al, [assert_actual_buf]
    assert_al_eq 0x41, __LINE__
    mov al, [assert_actual_buf + 1]
    assert_al_eq 0x05, __LINE__
    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x03, __LINE__

    ; the chunk header packer should not increment the sequence number

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 69
    mov rsi, assert_actual_buf
    call pack_chunk_header


    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x03, __LINE__

test_pack_chunk_header_big_size_and_big_seq:
    mov dword [connection_sequence], 1023

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 69
    mov rsi, assert_actual_buf
    call pack_chunk_header

    mov al, [assert_actual_buf]
    assert_al_eq 0x41, __LINE__
    mov al, [assert_actual_buf + 1]
    assert_al_eq 0xc5, __LINE__
    mov al, [assert_actual_buf + 2]
    assert_al_eq 0xff, __LINE__

    ; the chunk header packer should not increment the sequence number

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 69
    mov rsi, assert_actual_buf
    call pack_chunk_header


    mov al, [assert_actual_buf + 2]
    assert_al_eq 0xff, __LINE__


test_pack_queue_chunk:
    call packet_packer_reset

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
    assert_al_eq 0x40, __LINE__
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 1]
    assert_al_eq 0x03, __LINE__ ; payload size 2 plus 1 byte message id
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x0A, __LINE__

    ; call again to verify sequence incrementing
    call packet_packer_reset

    ; rax: flags
    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL

    mov rdi, assert_input_buf

    call queue_chunk

    ; asserts
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x0B, __LINE__


    ; call again to verify sequence incrementing even more
    call packet_packer_reset

    ; rax: flags
    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL

    call queue_chunk

    ; asserts
    mov al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x0C, __LINE__

    end_test __LINE__
