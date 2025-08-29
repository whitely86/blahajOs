[BITS 16]    ; specify to the assembler that i will use 16 bit code
[ORG 0x7c00] ; specify to the assembler where i expect this code to be loaded

_start:
    mov [DISK_NUM], dl                 

    cli
    xor ax, ax                          
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov bp, 0x7c00
    mov sp, bp
    sti

    mov al, 1
    mov dh, 0
    mov ch, 0
    mov cl, 2
    mov dl, [DISK_NUM]
    mov bx, 0x7e00
    call disk_read

    jmp 0x0000:0x7e00

    cli
    hlt

disk_error:
    mov si, strDiskError
    call puts
    jmp reboot
reboot:
    mov ah, 0
    int 0x16
    jmp 0xFFFF:0

; disk_read
; parameters:
;   al - num. of sectors you wanna read
;   dh - starting head
;   ch - starting track
;   cl - starting sector
;   dl - disk number
;   bx - buffer
; return: none
disk_read:
    pusha
    mov ah, 2
    mov di, 3
.loop:
    int 0x13
    jnc .done
    call disk_reset

    dec di
    test di, di
    jnz .loop
    jmp disk_error
.done:
    popa
    ret

; disk_reset
; parameters: none
; return: none
disk_reset:
    pusha
    mov ah, 0
    int 0x13
    jc disk_error
    popa
    ret

; puts
; parameters:
;   si - string to print
; return: none
puts:
    push ax
    push si
.loop:
    lodsb
    cmp al, 0
    je .end
    mov ah, 0x0e
    int 0x10
    jmp .loop
.end:
    pop si
    pop ax
    ret

STAGE2_LOCATION equ 0x7e00

DISK_NUM: db 0
strDiskError: db "disk error", 13, 10, 0

; master boot record
times 510 - ($ - $$) db 0              
db 0x55, 0xaa