BITS 32
global _start
section .data
    defaultstr db `y`,`\n`

section .text
_start:
    pop ebx             ;Get argument count
    dec ebx             ;If there are no arguments just exit instantly
    jz _noArgs
    
    add esp, 4          ;Remove program name from the stack, we don't need it
    pop	ecx	        ;Get first argument
    dec ebx
    jz _final_arg ;check if we're already on the final argument
    _most_args:
        pop edx
        mov byte [edx-1], ` `
        dec ebx
        jnz _most_args

    _final_arg: ;only get strlen for the final argument
	;Remove the null between argv and envp and get the first bit of 
	;envp, basically combining add esp, 4 and pop edx.
	;We can do this because we no longer need to keep track of the 
	;stack after this.
	mov edx, [esp+4]
_exit:
    ;Append a newline to the end
    mov byte [edx], `\n`
    inc edx
    ;String pointer is already in ecx
    sub edx, ecx     ; String length
    inc ebx          ; stdout
_loop:
    ; Print the string
    mov eax, 4 ;sys_write
    push _loop
    push ecx
    push edx
    push ebp
    mov ebp, esp
    sysenter        ; Kernel interrupt
_noArgs:
    inc ebx ;stdout
    mov ecx, defaultstr
    mov edx, 2 ;length
    jmp _loop
