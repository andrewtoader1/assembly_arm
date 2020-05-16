	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s    

	IMPORT LCD_Initialization
	IMPORT LCD_Clear		
	IMPORT LCD_DisplayString

	AREA    main, CODE, READONLY
	EXPORT	__main				; make __main visible to linker
	ENTRY			
		
__main	PROC
	
	; Configure and clear the LCD Display
	BL  LCD_Initialization
	BL  LCD_Clear
	
	; Enable the clock for GPIO A and GPIO E
	LDR r0, =RCC_BASE
	LDR r1, [r0, #RCC_AHB2ENR]
	LDR r2, =0x00000011
	ORR r1, r1, r2
	STR r1, [r0, #RCC_AHB2ENR]
	
	; Configure output pins: we are using pins PE10, PE11, PE12, PE13
	
	; Configure the GPIOE as output
	LDR r0, =GPIOE_BASE
	LDR r1, [r0, #GPIO_MODER]
	LDR r2, =0x0AA00000
	BIC r1, r1, r2
	LDR r2, =0x05500000
	ORR r1, r1, r2
	STR r1, [r0, #GPIO_MODER]
	
	; Configure output type as open drain
	LDR r0, =GPIOE_BASE
	LDR r1, [r0, #GPIO_OTYPER]
	LDR r2, =0x3C00
	ORR r1, r1, r2
	STR r1, [r0, #GPIO_OTYPER]
	
	
	; Configure output pins: we are using pins PE10, PE11, PE12, PE13
	
	; Configure GPIOA as input
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_MODER]
	LDR r2, =0x00000CFC
	BIC r1, r1, r2
	STR r1, [r0, #GPIO_MODER]
	


		; Pull all rows low
pdr		LDR r0, =GPIOE_BASE
		LDR r1, [r0, #GPIO_ODR]
		LDR r2, =0x00003C00		; clear bits 10-13
		BIC r1, r1, r2
		STR r1, [r0, #GPIO_ODR]

		BL delay_func			; Call the delay function

		BL col1_check			; call function to check if all rows are one
		CMP r3, #0				; check output of last function and branch back to pulling all rows low if all column inputs are 1
		BEQ pdr
		
		LDR r0, =GPIOE_BASE			; pull down the first row
		LDR r1, [r0, #GPIO_ODR]
		LDR r2, =0x00000400
		BIC r1, r1, r2
		LDR r2, =0x00003800
		ORR r1, r1, r2
		STR r1, [r0, #GPIO_ODR]
		LDR r4, =1					; store 1 in register to signal that we are modifying first row
		
		BL delay_func			; call delay function
		
		BL col1_check			; call function which checks if all columns are 1
		CMP r3, #0				; if a key is pressed, branch to part of code that tests all colums
		BNE test_c
		
		LDR r0, =GPIOE_BASE			; pull down the second row
		LDR r1, [r0, #GPIO_ODR]
		LDR r2, =0x00000800
		BIC r1, r1, r2
		LDR r2, =0x00003400
		ORR r1, r1, r2
		STR r1, [r0, #GPIO_ODR]
		LDR r4, =2					; store 2 in register to signal that we are modifying second row
		
		BL delay_func			; call delay function
		
		BL col1_check			; call function which checks if all columns are 1
		CMP r3, #0				; if a key is pressed, branch to part of code that tests all colums
		BNE test_c
		
		LDR r0, =GPIOE_BASE			; pull down the third row
		LDR r1, [r0, #GPIO_ODR]
		LDR r2, =0x00001000
		BIC r1, r1, r2
		LDR r2, =0x00002C00
		ORR r1, r1, r2
		STR r1, [r0, #GPIO_ODR]
		LDR r4, =3					; store 3 in register to signal that we are modifying thrid row
		
		BL delay_func			; call delay function
		
		BL col1_check			; call function which checks if all columns are 1
		CMP r3, #0				; if a key is pressed, branch to part of code that tests all colums
		BNE test_c

		LDR r0, =GPIOE_BASE			; pull down the fourth row
		LDR r1, [r0, #GPIO_ODR]
		LDR r2, =0x00002000
		BIC r1, r1, r2
		LDR r2, =0x00001C00
		ORR r1, r1, r2
		STR r1, [r0, #GPIO_ODR]
		LDR r4, =4					; store 4 in register to signal that we are modifying fourth row
		
		BL delay_func			; call delay function
		
		BL col1_check			; call function which checks if all columns are 1
		CMP r3, #0				; if a key is pressed, branch to part of code that tests all colums
		BNE test_c
		
		B pdr					; if all column inputs are 1 then branch to pull down all rows
		
test_c	SUB r0, r3, #1			; subtract 1 from column
		SUB r1, r4, #1			; subtract 1 from row
		
		LSL r1, #2
		
		ADD r2, r0, r1			; r2 hold the index of the charachter we want
		
		LDR r5, =keypad_lay
		LDRB r6, [r5, r2]
		
		LDR r0, =disp_str
		LDRB r1, [r0, #4]
		STRB r1, [r0, #5]
		
		LDRB r1, [r0, #3]
		STRB r1, [r0, #4]
		
		LDRB r1, [r0, #2]
		STRB r1, [r0, #3]
		
		LDRB r1, [r0, #1]
		STRB r1, [r0, #2]
		
		LDRB r1, [r0, #0]
		STRB r1, [r0, #1]
		
		STRB r6, [r0]
	
		PUSH {r0, r1, r2, r3}		; push registers to stack because coll_check uses them
		
key_c	BL col1_check
		CMP r3, #0
		BNE key_c
		
		POP {r0, r1, r2, r3}		; get back the values stored on the stack
	
		BL  LCD_DisplayString
		
		B pdr

;;;;;;;;;;;; DELAY FUNCTION ;;;;;;;;;;;;;;;;;;;;;;;;
delay_func	LDR r1, =1000
delay		CMP r1, #0			; Compare delay with 0
			BLE d_done			; exit loop if delay is 0
			SUB r1, r1, #1		; decrement delay if it is not 0
			B delay
d_done		BX LR

;;;;;;;;;;;;;;;;; COLUMN CHECKER FUNCTION ;;;;;;;;;;;;
; modifies regiesters r0, r1, r2, r3
; return value is stored in r3, and signifies the collumn which is pressed. 0 means no column is pressed
col1_check	LDR r0, =GPIOA_BASE		; check if all colums are 1
			LDR r1, [r0, #GPIO_IDR]
			LDR r2, =0xFFFFFFFD
			ORR r1, r1, r2
			CMP r1, r2
			BEQ col1
			
			LDR r2, =0xFFFFFFFB		; same instruction as above, but change the mask for the second column
			LDR r1, [r0, #GPIO_IDR]
			ORR r1, r1, r2
			CMP r1, r2
			BEQ col2

			LDR r2, =0xFFFFFFF7		; same instruction as above, but change the mask for the second column
			LDR r1, [r0, #GPIO_IDR]
			ORR r1, r1, r2
			CMP r1, r2
			BEQ col3
			
			LDR r2, =0xFFFFFFDF		; same instruction as above, but change the mask for the second column
			LDR r1, [r0, #GPIO_IDR]
			ORR r1, r1, r2
			CMP r1, r2
			BEQ col4
			
			LDR r3, =0
			BX LR
			
col1		LDR r3, =1		; load column number in register if buton is pressed
			BX LR
			
col2		LDR r3, =2
			BX LR
			
col3		LDR r3, =3
			BX LR
	
col4		LDR r3, =4
			BX LR
ENDP
	
	ALIGN	
	AREA myData, DATA, READWRITE
	ALIGN
keypad_lay  DCB "123A456B789C*0#D",0		; Store in data an array to be able to acess indexed variables
disp_str	DCB "      ",0					; The String to display

	END
		
		
		
		
		
		