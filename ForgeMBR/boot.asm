; boot.asm — ForgeMBR Stage 1 Bootloader (512 bytes)
[org 0x7C00]

start:
    ; Reset segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Display bootloader startup message
    mov si, msg
    call print_string

    ; Load 1 sector from disk into 0x8000 (second stage)
    mov ah, 0x02      ; BIOS read function
    mov al, 1         ; Number of sectors
    mov ch, 0         ; Cylinder
    mov cl, 2         ; Sector 2 (MBR is sector 1)
    mov dh, 0         ; Head
    mov dl, 0x00      ; Drive number (floppy = 0x00)
    mov bx, 0x8000    ; Buffer address
    int 0x13          ; BIOS interrupt

    jc disk_error     ; If carry flag is set, read failed

    ; Confirm kernel read success
    mov si, disk_ok_msg
    call print_string

    ; Jump to loaded kernel
    jmp 0x0000:0x8000

disk_error:
    mov si, error_msg
    call print_string
    jmp hang

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

hang:
    cli
    hlt
    jmp hang

msg db "SoulOS Bootloader Loaded. Loading Kernel...", 0
disk_ok_msg db " [Kernel Read OK]", 0
error_msg db " [Disk Read FAILED!]", 0

times 510 - ($ - $$) db 0
dw 0xAA55
