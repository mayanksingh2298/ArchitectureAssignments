	.equ SWI_Exit, 0x11
	.text
	mov r1, #8
	mov r4, r1
	ldr r3, =AA 
Lab1:
	str r2, [r3]
	add r3, r3, #4
	sub r2, r2, #1
	sub r1, r1, #1
	cmp r1, #0
	bne Lab1
	mov r1, #10
	mov r4, #0
	ldr r3, =AA
	mov r4, r1
	b OuterLoop 
SWP:
	str r2, [r3, #4]
	str r5, [r3]
	b Cont
OuterLoop:
	ldr r3, =AA
	mov r1, #10
InnerLoop:
	ldr r2, [r3]
	ldr r5, [r3, #4]
	cmp r2, r5
	bgt SWP
Cont:
	add r3, r3, #4
	sub r1, r1, #1
	cmp r1, #1
	bne InnerLoop
	sub r4, r4, #1
	cmp r4, #1
	bne OuterLoop

	
	ldr	r0, =OutFileName
	mov	r1, #1
	swi	SWI_Open
	@bcs OutFileError
	ldr	r1,=OutFileHandle
	str	r0, [r1]
    ldr r3, =AA
	mov r4, #0
Print:
	@ldr r0, [r3]
	
	add r3, r3, #4
	ldr r1, [r3]
	swi SWI_PrInt
	add r4, r4, #1
	cmp r4, #10
	bne Print
	swi SWI_Exit
	.data
LIST: .word[8,7,6,5,4,3,2,1]
	.end