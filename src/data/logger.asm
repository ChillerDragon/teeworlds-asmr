char_newline db 0x0a
char_space   db 0x20

s_dbg_rax_digit db "[debug] value of rax is: "
l_s_dbg_rax_digit equ $ - s_dbg_rax_digit

s_dbg_reg_digit db "[debug] value of register is: "
l_s_dbg_reg_digit equ $ - s_dbg_reg_digit

s_dbg_hexdump_register db "[debug] hexdumping register: "
l_s_dbg_hexdump_register equ $ - s_dbg_hexdump_register
