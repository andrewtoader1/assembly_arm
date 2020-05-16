	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s  

	AREA    main, CODE, READONLY
	EXPORT	__main				; make __main visible to linker
	ENTRY			
		
__main	PROC
	; Enable the clock for GPIO A and GPIO B
	LDR r0, =RCC_BASE
	LDR r1, [r0, #RCC_AHB2ENR]
	LDR r2, =0x00000003
	ORR r1, r1, r2
	STR r1, [r0, #RCC_AHB2ENR]
	
	; Configure output pins: we are using pins PB2, PB3, PB6, PB7
	
	; Configure the GPIOE as output
	LDR r0, =GPIOB_BASE
	
	LDR r1, [r0, #GPIO_MODER]
	LDR r2, =0xA0A0
	BIC r1, r1, r2
	LDR r2, =0x5050
	ORR r1, r1, r2
	STR r1, [r0, #GPIO_MODER]
	
	; Configure output type as push-pull
	LDR r1, [r0, #GPIO_OTYPER]
	BIC r1, r1, #0xCC
	STR r1, [r0, #GPIO_OTYPER]
	
	
	; Configure input pins: we are using pins PA3
	
	; Configure GPIOA as input
	LDR r0, =GPIOA_BASE
	
	LDR r1, [r0, #GPIO_MODER]
	LDR r2, =0xC0
	BIC r1, r1, r2
	STR r1, [r0, #GPIO_MODER]
	
	; configure GPIO as pull-down
	LDR r1, [r0, #GPIO_PUPDR]
	BIC r1, r1, #0xC0
	ORR r1, r1, #0x80
	STR r1, [r0, #GPIO_PUPDR]	
	
tur LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_IDR]
	LDR r3, =0xFFFFFFF7
	ORR r2, r1, r3
	CMP r2, r3
	BEQ tur
	BL turn_m
	B tur
	
	
	; function to step clockwise
cw	LDR r5, =GPIOB_BASE
	
	; step 1
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x84
	STR r1, [r5, #GPIO_ODR]
	
	; step 2
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x04
	STR r1, [r5, #GPIO_ODR]
	
	; step 3
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x44
	STR r1, [r5, #GPIO_ODR]
	
	; step 4
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x40
	STR r1, [r5, #GPIO_ODR]
	
	; step 5
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x48
	STR r1, [r5, #GPIO_ODR]
	
	; step 6
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x08
	STR r1, [r5, #GPIO_ODR]
	
	; step 7
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x88
	STR r1, [r5, #GPIO_ODR]
	
	; step 8
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x80
	STR r1, [r5, #GPIO_ODR]
	
	BX LR

	; function to step clockwise
ccw	LDR r5, =GPIOB_BASE

	; step 8
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x80
	STR r1, [r5, #GPIO_ODR]
	
	; step 7
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x88
	STR r1, [r5, #GPIO_ODR]
	
	; step 6
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x08
	STR r1, [r5, #GPIO_ODR]
	
	; step 5
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x48
	STR r1, [r5, #GPIO_ODR]
	
	; step 4
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x40
	STR r1, [r5, #GPIO_ODR]
	
	; step 3
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x44
	STR r1, [r5, #GPIO_ODR]
	
	; step 2
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x04
	STR r1, [r5, #GPIO_ODR]
	
	; step 1
	PUSH {LR}
	BL delay_func
	POP {LR}
	LDR r1, [r5, #GPIO_ODR]
	BIC r1, r1, #0xCC
	ORR r1, r1, #0x84
	STR r1, [r5, #GPIO_ODR]
	
	BX LR
	
	; Function that turns the motor 145 deg
turn_m	LDR r0, =206
		PUSH {LR}
while	CMP r0, #0
		BEQ next
		BL cw			; Branch to turn cw once function
		SUB r0, r0, #1
		B while
		
next	LDR r0, =206
turn_c	CMP r0, #0
		BEQ fin
		BL ccw			; Branch to turn ccw once function
		SUB r0, r0, #1
		B turn_c
		
fin		POP {LR}
		BX LR

	; Function that delays each step
delay_func	LDR r1, =1000
delay		CMP r1, #0			; Compare delay with 0
			BLE d_done			; exit loop if delay is 0
			SUB r1, r1, #1		; decrement delay if it is not 0
			B delay
d_done		BX LR

ENDP
		
		
		
		
		