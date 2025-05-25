; kernel.asm — SoulOS Kernel Stage 2
[org 0x8000]

start:
    ; Write white 'K' in top-left using proper 16-bit memory addressing
    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov byte [es:di], 'K'
    mov byte [es:di+1], 0x0F

    ; Show booted message
    mov si, msg
    call print_string

    cli
    hlt

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

msg db "SoulOS Kernel Loaded. Awaiting soul block...", 0

times 512 - ($ - $$) db 0
