on_system_msg6_null:
    ; on_system_msg6_null [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg6_map_change:
    ; on_system_msg6_map_change [rax]
    ;  rax = message payload

    mov rbp, rsp
    sub rsp, 2048 ; buffer for chat message

    ; index into msg stack buffer
    mov r9, -2048

    lea rax, [rbp+r9]
    mov rdi, c_map_change
    call str_copy
    add r9, rax

    call get_string
    mov rdi, rax ; arg for str_copy
    lea rax, [rbp+r9]
    call str_copy

    mov rax, c_client
    lea rdi, [rbp-2048]
    call log_info

    mov rsp, rbp

    call send_ready6

    jmp on_system_message_end
