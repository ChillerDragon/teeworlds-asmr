%include "tests/assert.asm"

_start:
    init_test __FILE__

    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 0x04
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 0x02
    assert_input_buf_push_byte 0xCC
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF

    ; call to be tested function
    mov rax, assert_input_buf
    call unpack_packet_header

    ; assert flags
    mov al, [in_packet_header_flags]
    assert_al_eq 0x04

    ; assert flags
    mov al, [in_packet_header_num_chunks]
    assert_al_eq 0x02

    ; assert token
    mov rax, [in_packet_header_token]
    assert_eax_eq 0xFFFFFFCC, __LINE__

    exit 0

