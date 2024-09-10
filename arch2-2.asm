;=============================================================================;
;                                                                             ;
; File           : arch2-2.asm                                                ;
; Format         : COM                                                        ;
; Exercise       : Get familiar with the representation of numbers in U2 code ; 
;                and characters in ASCII code.                                ;
; Authors        : Alicja Bartczak, Edyta Szymanska, gr 7, Thursday,   14:00  ;
; Submission Date: DD.MM.YEAR                                                 ;
; Notes          :  Write a .COM program that will read two integers from     ;
; the range [-32768..32767] and add them together,                            ;
; and display the result on the screen.                                       ;
;                                                                             ;
;=============================================================================;

            .386
            .MODEL TINY
Code        SEGMENT USE16
            ORG     100h 
            ASSUME  CS:Code, DS:Code, SS:Code
Start:
    jmp StartPoint
Authors     DB      "Alicja Bartczak, Edyta Szymanska",0Ah,0Dh,'$'
Message1    DB      0Dh,0Ah,"An error occurred",0Ah,0Dh,'$'
Message2    DB      0Dh,0Ah,"This is not a number",0Ah,0Dh,'$'
FirstNum    DB      0Dh,0Ah,"Enter the first number from the range [-32768,32767]:",'$'
SecondNum   DB      0Dh,0Ah,"Enter the second number from the range [-32768,32767]:",'$'
EndText     DB      0Dh,0Ah,"The result is:",'$'
MinusSign   DB      " - ",'$'
Result      DD      ?
Tablee      DB      8   DUP(?)
Negative1   DB      ?
Negative2   DB      ?
IfMinus     DB      00h
TableSize   DB      8
TableIndex  DB      02h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Error

Error0:    
    mov     dx, offset Message1
    mov     ah, 09h
    int     21h
    mov     ax, 4C00h
    int     21h
    jmp EndProgram
    
Error1:    
    mov     dx, offset Message1
    mov     ah, 09h
    int     21h
    mov     ax, 4C00h
    int     21h
    jmp EndProgram
        
Error2:
    mov     dx, offset Message2
    mov     ah, 09h
    int     21h
    mov     ax, 4C00h
    int     21h
    jmp EndProgram
    
test1:
    
     cmp     eax, 8000h
     je      test1
     cmp     eax, 7FFFh

check_negative1:
    cmp     Negative1, 0
    je      Positive1
    cmp     eax, 8000h              ;check if the number is less than 7FFFh
    ja      Error1      ;Jump if greater (unsigned) (CF=0 and ZF=0)
    jmp     ResultDisplay
    
check_negative2:
    cmp     Negative2, 0
    je      Positive2
    cmp     eax, 8000h              ;check if the number is less than 7FFFh
    ja      Error1      ;Jump if greater (unsigned) (CF=0 and ZF=0)
    jmp     Addition
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Changing the sign to negative number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Negative:
    mov     Negative1, bl
    inc     si
    dec     cl
    
    mov     bl, byte ptr [si]       ;bl = value of byte at address si
    cmp     bl, '0'                 ;check if the number(bl) is greater than 0
    je      Error2
    
    jmp     Continue

Negative2:
    mov     Negative2, bl
    inc     si
    dec     cl

    mov     bl, byte ptr [si]       ;bl = value of byte at address si
    cmp     bl, '0'                 ;check if the number(bl) is greater than 0
    je      Error2
    
    jmp     Continue3
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartPoint:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Fetching numbers from the console
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov     dx, offset Authors
    mov     ah, 09h
    int     21h
    
    mov     dx, offset FirstNum
    mov     ah, 09h
    int     21h

    mov     dx, offset TableSize
    mov     ah, 0Ah
    int     21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check if the number is negative
;Check if it has the correct length
;prepare registers for conversion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Conversion:
    mov     Negative1, 00h          ;resetting the sign of the number
    xor     cx, cx                  ;resetting cx
    mov     cl, TableIndex          ;cl = length of the table
    mov     ax, 02h                    
    add     ax, dx
    mov     si, ax                  ;si = table address
    mov     di, 0Ah                 ;di = 10
    mov     bl, byte ptr [si]       ;bl = value of byte at address si

    cmp     bl, '-'
    je      Negative                ; Jump if equal (ZF=1)

Continue:
    cmp     cl, 05h                 ; check if the table length exceeds the maximum
    ja      Error1                  ; Jump if greater (unsigned) (CF=0 and ZF=0)

    xor     eax, eax                ;reset eax
    xor     ebx, ebx                ;reset ebx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Convert ASCII => U2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Number:
    mul     di                      ;ax = ax*di
    mov     bl, byte ptr[si]        ;bl = value of byte at address si
    inc     si                      ;si = si+1

    cmp     bl, '0'                 ;check if the number(bl) is greater than 0
    jb      Error1                  ; Jump if less (unsigned) (CF=1)
    cmp     bl, '9'                 ;check if the number(bl) is less than 9
    ja      Error1                  ; Jump if greater (unsigned) (CF=0 and ZF=0)

    sub     bl, '0'                 ;bl = bl - '0'(30)
    add     ax, bx                  ; ax = ax + bx
    dec     cx                      ; cx = cx -1
    cmp     cx, 00h                 ; is it the end of the table?
    jne     Number                  ;Jump if not equal (ZF=0)

    mov     bl, Negative1           ; bl = Negative1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check if the number has the correct value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Continue2:

    cmp     eax, 7FFFh
    ja      check_negative1
    
Positive1:

    cmp     eax, 7FFFh              ;check if the number is less than 7FFFh
    ja      Error1                  ;Jump if greater (unsigned) (CF=0 and ZF=0)

ResultDisplay:
    mov     Result, eax             ; result = eax

Conversion2:
    xor     eax, eax                ;reset eax
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reading the second number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov     dx, offset SecondNum        
    mov     ah, 09h
    int     21h

    mov     dx, offset TableSize
    mov     ah, 0Ah
    int     21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check if the number is negative
;Check if it has the correct length
;prepare registers for conversion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov     Negative2, 00h          ;resetting the sign of the number
    xor     cx, cx                  ;resetting cx
    mov     cl, TableIndex          ;cl = length of the table
    mov     ax, 02h
    add     ax, dx
    mov     si, ax                  ;si = table address
    mov     di, 0Ah                 ;di = 10
    mov     bl, byte ptr [si]       ;bl = value of byte at address si
    
    cmp     bl, '-'
    je      Negative2               ; Jump if equal (ZF=1)

Continue3:
    cmp     cl, 06h                 ; check if the table length exceeds the maximum
    ja      Error1                  ; Jump if greater (unsigned) (CF=0 and ZF=0)

    xor     eax, eax                ;reset eax
    xor     ebx, ebx                ;reset ebx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Convert ASCII => U2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Number2:
    mul     di                      ;ax = ax*di
    mov     bl, byte ptr[si]        ;bl = value of byte at address si
    inc     si                      ;si = si+1

    cmp     bl, '0'                 ;check if the number(bl) is greater than 0
    jb      Error1                  ; Jump if less (unsigned) (CF=1)
    cmp     bl, '9'                 ;check if the number(bl) is less than 9
    ja      Error1                  ; Jump if

	sub		bl, '0'					; bl = bl - '0'(30)
	add		ax, bx					; ax = ax + bx
	dec     cx						; cx = cx -1
	cmp 	cx, 00h					; is this the end of the table?
	jne 	Liczba2					; Jump if not equal (ZF=0)

	mov		bl, Negative2			; bl = Negative2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Is the number within a valid range
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Kontynuacja4:

		cmp 	eax, 7FFFh
	ja 		czy_ujemna2
	
Dodatnia2:

	cmp		eax, 8000h				; is the number smaller than 7FFFh
	ja		Blad1					; Jump if greater (unsigned) (CF=0 and ZF=0)
 
Addition:
	 
	 mov	ebx, Result				; ebx = Result
	 xor 	cx, cx					; zero out cx
	 
	 
	 cmp 	Negative1, '-'			; is the first number negative
	 je 	sprawdz1				; Jump if equal (ZF=1)
	 
	 cmp 	Negative2, '-'			; is the second number negative
	 je 	sprawdz2				; Jump if equal (ZF=1)
	 
	 add	eax, ebx				; eax = eax + ebx
	 jmp 	Next					; jump to next

Check1:
	 cmp 	Negative2, '-'
	 je		BothNegative
	 cmp 	eax, ebx
	 je		Equal
	 ja		Negative1EAXGreater
	 jmp 	Negative1EBXGreater
	 
 Check2:
	 cmp 	Negative1, '-'
	 je		BothNegative
	 je		Equal
	 cmp 	ebx, eax
	 ja		Negative2EBXGreater
	 jmp 	Negative2EAXGreater
 
 Negative1EAXGreater:
	 sub 	eax, ebx;
	 jmp 	Next
 
 Negative1EBXGreater:
	 sub 	ebx, eax;
	 mov 	eax, ebx
	 mov 	IfMinus, '-'
	 jmp 	Next
 
 Negative2EAXGreater:
	 sub 	eax, ebx;
	 mov 	IfMinus, '-'
	 jmp 	Next
 
 Negative2EBXGreater:
	 sub 	ebx, eax;
	 mov 	eax, ebx
	 jmp 	Next
	 
Equal:
	xor eax, eax
	jmp Next;
 
BothNegative:
	add 	eax, ebx;
	mov 	IfMinus, '-'
	
	jmp 	Next
	
Next:
	xor		dx, dx
	xor		ebx, ebx				; zero out bx
	xor		ebx, ebx
	mov		ebx, 0Ah

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Conversion from two's complement to ASCII
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ConvertU2toASCII:

	xor 	dx, dx
	div 	ebx	 					; eax / ebx => dx remainder, ax result

	add 	dx, '0'
	push 	dx
	inc 	cx
	cmp 	eax, 0h
	je 		DisplayString			; Jump if equal (ZF=1)
	jmp 	ConvertU2toASCII

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Displaying the result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DisplayString:
	mov		dx, offset EndText
	mov 	ah, 09h
	int 	21h
	cmp 	IfMinus, '-'
	je 		Minus					; Jump if equal (ZF=1)
	jmp 	Display

Minus:
	mov		dx,	offset MinusSign
	mov 	ah, 09h
	int 	21h
	jmp 	Display

Display:

	pop		dx
	mov 	ah, 02h
	int		21h
	dec     cx
	cmp 	cx, 00h
	jne 	Display 		; Jump if not equal
	jmp 	end

end:
	mov 	ax, 4C00h
	int 	21h
				
Code		ENDS
END Start
