; global _start

; _start:
;     xor esi, esi
;     add esi, 4
;     add esi, esi

;     mov eax, 0x03
;     mov ebx, 1
;     mov ecx, esi
;     mov edx, 6
;     int 0x80

;     xor eax, eax
;     int 0x80

; global _start

; _start:
;     xor esi, esi
;     add esi, 4
;     add esi, esi

;     mov eax, 0x03
;     mov ebx, 1
;     mov ecx, esi
;     mov edx, 6
;     int 0x80

;     xor eax, eax
;     int 0x80


; global _start

; _start:
;     ; ajoute 4 dans eax
;     mov eax, 4 ; B8 04 00 00 00
;     ; ajoute 4 dans ebx
;     mov ebx, 4 ; BB 04 00 00 00
;     ; additionne eax et ebx et le mets dans eax
;     add eax, ebx ; 01 D8
;     ; ajoute 0x30 dans eax (passage en ASCII)
;     add eax, 0x30 ; 05 30 00 00 00
;     ; push eax dans la stack
;     push eax ; 50
    
;     ; Permet d'afficher 1 caractère => 8
;     mov eax, 4 ; B8 04 00 00 00
;     mov ebx, 1 ; BB 01 00 00 00
;     mov ecx, esp ; 89 E1
;     mov edx, 1 ; BA 01 00 00 00
;     int 80h ; CD 80

;     ; exit
;     mov eax, 1 ; B8 01 00 00 00
;     xor ebx, ebx ; 31 DB
;     int 80h ; CD 80


# push => 1230
# mov => 745
# xor => 2062
# ADD : 135




; global _start

; _start:
;     mov al, 4 ; B0 04
;     add al, al ; 02 C0
;     add al, 0x30 ; 04 30
;     push ax ; 50

;     mov al, 4 ; B0 04
;     mov bl, 1 ; B4 01
;     mov ecx, esp ; 89 E1
;     mov dl, 1 ; B3 01
;     int 80h ; CD 80

;     ; exit
;     mov al, 1 ; B0 01
;     xor ebx, ebx ; 31 DB
;     int 80h ; CD 80


global _start

_start:
    mov al, 4 ; B0 04
    add al, 0x34 ; 04 34
    push ax ; 50

    mov al, 4 ; B0 04
    mov bl, 1 ; B4 01
    mov ecx, esp ; 89 E1
    mov dl, 1 ; B3 01
    int 80h ; CD 80

    ; exit
    mov al, 1 ; B0 01
    xor ebx, ebx ; 31 DB
    int 80h ; CD 80


; 60 # PUSHAD
; 61 # POPAD
; 9C # => PUSHFD (pour push les flags)

# push 0x1
# pop eax

# Voir comment mettre en place un AES
# Encode : AESENC(9) PUIS AESENCLAST(1) 
# Decode : AESENCLAST(1) PUIS AESDEC(1), AESKEYGENASSIST

