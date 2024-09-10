;=============================================================================;
;                                                                             ;
; File           : arch3-2.asm                                                ;
; Format         : EXE                                                        ;
; Exercise       : Familiarizing with methods of creating hybrid programs     ;
; and the possibilities of using and the purpose of using assembler           ;
; procedures in high-level language programs.                                 ;
; Authors        : Alicja Bartczak, Edyta Szymanska, group 7, Thursday, 14:00  ;
; Submission Date: DD.MM.YEAR                                                 ;
; Notes          : Write a hybrid program where the main module is written    ;
; in a high-level language, and auxiliary procedures are in a separate        ;
; assembly module. The main module should only gather input from the user     ;
; and display the results, while the additional module should contain         ;
; at least two procedures written in assembly, called from the main module.   ;
;                                                                             ;
;=============================================================================;

		.MODEL SMALL, C; adaptation to naming convention compatible with C language
		.CODE

		PUBLIC average_of_array
		PUBLIC count_character

; In the first variant, calculate the average of an array of real numbers.
average_of_array	PROC

		push 	bp 				; save the old value of BP
		mov		bp, sp 			; set a new value to the current stack top
		sub 	sp, 4			; reserve 4 bytes on the stack for 2 two-byte local variables
		mov 	cx, [bp+6]		; length of the array - get the second parameter
		mov		si, [bp+4]		; start of the array - get the first parameter
		fld		qword ptr [si]  ; load a 64-bit (double) value from memory
		add		si, 8           ; move the array start pointer by 8 bytes - the array contains double elements
		dec		cx				; decrement - iterate through the array
		
	loop_average:
		fadd	qword ptr [si] 	; load the number and add it to the coprocessor
		add 	si, 8			; move to the next number
		sub		cx, 1			; loop counter decreased by 1
		cmp		cx, 0			; check if it's the end of the array
		jne		loop_average	; jump if not equal
		
		fidiv	word ptr [bp+6] ; divide the two numbers on the coprocessor stack
		mov		sp, bp       
		pop 	bp              ; restore the old value of bp
		ret                     ; return from procedure
		
average_of_array 	ENDP

; In the second variant, count the occurrences of a specified character in a string.
count_character		PROC

		push 	bp 				; save the old value of BP
		mov		bp, sp 			; set a new value to the current stack top
		sub 	sp, 4			; reserve 4 bytes on the stack for 2 two-byte local variables
		mov 	al, [bp+6]		; which character
		mov		si, bp   		; start of the array
		add		si, 12          ; move the pointer to the start of the array
		mov 	cx, 0
		dec 	si              ; prepare the register for loop iteration
		
	comparison:
		inc 	si                 
		mov  	ah, byte ptr [si]  ; fetch the next character from the array
		cmp 	ah, 0              ; check if it's the end of the character array
		je 		after_loop         ; jump if equal
		cmp		ah, al             ; compare the character from the array with the given character
		je		addition           ; jump if equal
		jmp 	comparison
		
	addition:
		inc 	cx
		jmp 	comparison

	after_loop:
		mov  	ax, cx           
		mov		sp, bp
		pop 	bp               ; restore the old value of bp
		ret                      ; return from procedure
count_character		ENDP

	END
