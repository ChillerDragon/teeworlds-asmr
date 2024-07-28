%include "tests/assert.asm"
%include "src/packet_header.asm"

_start:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 0x04
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 0xCC
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF

    ; call to be tested function
    mov rax, assert_input_buf
    call unpack_packet_header

    ; assert flags
    mov al, [packet_header_flags]
    assert_al_eq 0x04

    ; assert token
    mov rax, [packet_header_token]
    assert_eax_eq 0xFFFFFFCC

    exit 0

