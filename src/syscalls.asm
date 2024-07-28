; exit [exit code]
%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

