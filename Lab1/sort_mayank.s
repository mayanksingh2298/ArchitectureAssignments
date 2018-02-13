	.equ SWI_Exit, 0x11
	.text
	mov r1, #7
	@ mov r2, #1
	ldr r3, =HARD
	mov r5, #4 @constant 4
	mov r8, #1
swp:
	mul r6, r1, r5	
	ldr r4, [r3] @tmp
	ldr r7, [r3, r6] @tmp
	str r4, [r3, r6]
	str r7, [r3]

	add r3, r3, #4
	sub r1, r1, #2
	add r8, r8, #1

	cmp r8, #8
	bne swp

	ldr r3, =HARD
	swi SWI_Exit
	.data
HARD: .word 8,7,6,5,4,3,2,1
	.end