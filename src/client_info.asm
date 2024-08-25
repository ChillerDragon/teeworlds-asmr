; TW_CLIENT_ID_OFFSET equ 0
; TW_CLIENT_NAME_OFFSET equ TW_CLIENT_ID_OFFSET + 4
; TW_CLIENT_CLAN_OFFSET equ TW_CLIENT_NAME_OFFSET + MAX_NAME_ARRAY_SIZE
; TW_CLIENT_SIZE equ TW_CLIENT_CLAN_OFFSET + MAX_CLAN_ARRAY_SIZE

set_client_info:
    ; set_client_info [rax] [rdi]
    ;  rax = client id
    ; needs unpacker to be at team field of the SV_CLIENTINFO msg
    ; https://chillerdragon.github.io/teeworlds-protocol/07/game_messages.html#NETMSGTYPE_SV_CLIENTINFO_team
    push_registers

    ; rsi is pointer into clients array
    mov rbx, rax
    imul rbx, TW_CLIENT_SIZE
    lea rsi, [tw_clients + rbx]

    ; pop team
    call get_int

    ; name
    call get_string
    mov rdi, rax
    lea rax, [rsi+TW_CLIENT_NAME_OFFSET]
    call str_copy

    pop_registers
    ret

