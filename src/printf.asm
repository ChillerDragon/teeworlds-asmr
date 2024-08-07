%define MAX_PRINTF_ARGS 2

%macro printf 1-*
    ; amount of args 1 based
    ; without format string
    ;
    ;  printf "foo %s", "bar"         => 1 arg
    ;  printf "foo %d %s", 10, "bar"  => 2 arg
    ;
    %xdefine num_args %count(%{2:-1})

    %if num_args == 1
        printf_args_1 %1, %{2:-1}
    %elif num_args == 2
        printf_args_2 %1, %{2:-1}
    %else
        jmp %%error_many_args
    %endif

    jmp %%okay_many_args

    ; todo: set all 8 ...

    %%error_many_args:

    puts  "error: tried to call printf with too many arguments"
    print "  max: "
    mov rax, MAX_PRINTF_ARGS
    call println_int32
    print "  got: "
    mov rax, num_args
    call println_int32
    exit 1

    %%okay_many_args:
%endmacro

; ARGS 1

%macro printf_args_1 2
    ; printdf [format str] [int]
    push_registers

    ; TODO: do not segfault when we write out of those bounds
    %define MAX_PRINTF_LEN 2048

    ; rax = is null terminated format str
    str_to_stack %1

    sub rsp, MAX_PRINTF_LEN
    ; r10 is index in final output string
    mov r10, 0
    ; r11 is pointer to start of output string
    lea r11, [rbp-MAX_PRINTF_LEN]

    mov rcx, 0
%%printf_fmt_char_loop:
    mov r9b, byte [rax+rcx]
    inc rcx

    ; copy one letter from the format string
    ; to the output buffer
    mov byte [r11+r10], r9b
    inc r10

    cmp r9b, '%'
    jne %%printf_fmt_char_loop_check_repeat

%%printf_fmt_char_loop_got_percentage:
    mov r9b, byte [rax+rcx]
    cmp r9b, 'd'
    jne %%printf_fmt_char_loop_check_repeat

%%printf_fmt_char_loop_got_fmt_d:

    ; overwrite the %d
    dec r10
    inc rcx

    push rax
    push rdi

    mov rax, %2
    lea rdi, [r11+r10]
    call int32_to_str
    add r10, rax

    pop rdi
    pop rax
%%printf_fmt_char_loop_check_repeat:

    cmp r9b, 0
    jne %%printf_fmt_char_loop

    ; print output buffer
    printn r11, r10

    ; frees stack string
    ; and copy buffer
    mov rsp, rbp

    ; TODO: support \n escape sequence
    call print_newline

    pop_registers
%endmacro

; ARGS 2

; this is basically a copy of args 1
; there has to be a neater way to do this
;
; if it wasnt a macro but a function
; it could partially replace only one argument at a time
; and then it could be called recursively

%macro printf_args_2 3
    ; printdf [format str] [int] [int]
    push_registers

    ; TODO: do not segfault when we write out of those bounds
    %define MAX_PRINTF_LEN 2048

    ; rax = is null terminated format str
    str_to_stack %1

    ; r8 is the arg index
    ; we increment before compare
    ; so 1 = is the first
    ; but it will be %2 because %1 is the fmt string
    mov r8, 0

    sub rsp, MAX_PRINTF_LEN
    ; r10 is index in final output string
    mov r10, 0
    ; r11 is pointer to start of output string
    lea r11, [rbp-MAX_PRINTF_LEN]

    mov rcx, 0
%%printf_fmt_char_loop:
    mov r9b, byte [rax+rcx]
    inc rcx

    ; copy one letter from the format string
    ; to the output buffer
    mov byte [r11+r10], r9b
    inc r10

    cmp r9b, '%'
    jne %%printf_fmt_char_loop_check_repeat

%%printf_fmt_char_loop_got_percentage:
    mov r9b, byte [rax+rcx]
    cmp r9b, 'd'
    jne %%printf_fmt_char_loop_check_repeat

%%printf_fmt_char_loop_got_fmt_d:

    ; overwrite the %d
    dec r10
    inc rcx

    push rax
    push rdi

    inc r8

    cmp r8, 1
    je %%printf_fmt_char_loop_got_fmt_d_arg_1

    cmp r8, 2
    je %%printf_fmt_char_loop_got_fmt_d_arg_2

    puts "printf 2 unsupported amount of args"
    exit 1

%%printf_fmt_char_loop_got_fmt_d_arg_1:
    mov rax, %{2:2}
    lea rdi, [r11+r10]
    call int32_to_str
    add r10, rax
    jmp %%printf_fmt_char_loop_got_fmt_d_arg_end

%%printf_fmt_char_loop_got_fmt_d_arg_2:
    mov rax, %{3:3}
    lea rdi, [r11+r10]
    call int32_to_str
    add r10, rax

%%printf_fmt_char_loop_got_fmt_d_arg_end:

    pop rdi
    pop rax
%%printf_fmt_char_loop_check_repeat:

    cmp r9b, 0
    jne %%printf_fmt_char_loop

    ; print output buffer
    printn r11, r10

    ; frees stack string
    ; and copy buffer
    mov rsp, rbp

    ; TODO: support \n escape sequence
    call print_newline

    pop_registers
%endmacro
