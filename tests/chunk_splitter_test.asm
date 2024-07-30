%include "tests/assert.asm"

test_message_callback:
    push_registers

    mov eax, [assert_counter]
    inc eax
    mov [assert_counter], eax

    pop_registers
    ret

_start:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 0x04
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 0x02
    assert_input_buf_push_byte 0xCC
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF


    mov dword [assert_counter], 0

    ;  rax = payload buffer
    mov rax, assert_input_buf
    ;  rdi = chunk callback
    mov rdi, test_message_callback
    call on_system_or_game_messages

    mov rax, [assert_counter]
    ; assert_eax_eq 4

    exit 0
