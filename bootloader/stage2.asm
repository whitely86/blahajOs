[BITS 16]    ; specify to the assembler that i will use 16 bit code
[ORG 0x7e00] ; specify to the assembler where i expect this code to be loaded

KERNEL_LOCATION equ 0x1000

_start:
    mov [DISK_NUM], dl

    mov al, 2
    mov dh, 0
    mov ch, 0
    mov cl, 4
    mov dl, [DISK_NUM]
    mov bx, KERNEL_LOCATION
    call disk_read

    jmp enter_pm

%include "tables/gdt.inc"

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

enter_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or ax, 1
    mov cr0, eax
    
    jmp CODE_SEG:_start32

[BITS 32]
_start32:
    mov eax, DATA_SEG
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov ss, eax

    mov ebp, 0x90000
    mov esp, ebp

    in al, 0x92
    or al, 2
    out 0x92, al

    jmp KERNEL_LOCATION
    jmp $

DISK_NUM: db 0
strDiskError: db "disk error", 13, 10, 0

times 1024 - ($ - $$) db 0