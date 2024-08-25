section .data
    _con_str_quit db "quit", 0
    _con_str_ping db "ping", 0
    _con_str_connect db "connect", 0


    s_console_got_command db "[console] got command '"
    l_s_console_got_command equ $ - s_console_got_command
    s_console_with_args db "' with args '"
    l_s_console_with_args equ $ - s_console_with_args
    s_console_unknown_command db "[console] unknown command '"
    l_s_console_unknown_command equ $ - s_console_unknown_command
    s_console_pong db "[console] pong", 0x0a
    l_s_console_pong equ $ - s_console_pong
section .text

