%define MAX_PRINTF_ARGS 2

%macro printf 1-*
    push_registers
    ; amount of args 1 based
    ; without format string
    ;
    ;  printf "foo %s", "bar"         => 1 arg
    ;  printf "foo %d %s", 10, "bar"  => 2 arg
    ;
    %xdefine num_args %count(%{2:-1})

    %if num_args == 1
        mov qword [printf_arg_1_buf], %{2:2}
        printf_args_2 %1, 1
    %elif num_args == 2
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        printf_args_2 %1, 2
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
    pop_registers
%endmacro

%macro printf_args_2 2
    ; printdf [format str] [num args]
    ;  needs the labels [printf_arg_1_buf] and [printf_arg_2_buf] to be filled
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

    mov rbx, r8
    imul rbx, 8

    inc r8

%%printf_fmt_char_loop_got_fmt_d_arg:
    mov rax, [printf_arg_1_buf+rbx]
    lea rdi, [r11+r10]
    call int32_to_str
    add r10, rax

    pop rdi
    pop rax
%%printf_fmt_char_loop_check_repeat:

    cmp r9b, 0
    jne %%printf_fmt_char_loop

    ; print output buffer
    dec r10
    printn r11, r10

    ; frees stack string
    ; and copy buffer
    mov rsp, rbp

    ; TODO: support \n escape sequence
    call print_newline

    cmp r8, %2
    je %%printf_args_end

    puts "error: printf number of args does not match number of args in format string"
    exit 1

    %%printf_args_end:

    pop_registers
%endmacro

