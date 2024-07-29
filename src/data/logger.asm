char_newline db 0x0a
char_space   db 0x20

s_dbg_rax_digit db "[debug] value of rax is: ", 0
l_s_dbg_rax_digit equ $ - s_dbg_rax_digit

s_dbg_reg_digit db "[debug] value of register is: ", 0
l_s_dbg_reg_digit equ $ - s_dbg_reg_digit
