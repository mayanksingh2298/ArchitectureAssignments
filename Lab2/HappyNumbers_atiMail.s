	.equ SWI_Exit, 0x11
	.equ SWI_Open, 0x66
	.equ SWI_Close, 0x68
	.equ SWI_PrInt, 0x6b
	.equ SWI_PrStr, 0x69
	.equ Stdout, 1
	.text
	ldr r0, =OutFileName   ;opening the file
	mov r1, #1
	swi SWI_Open
	bcs NoFileFound

	; mov r0,#0  @counts the happy numbers
	mov r9,#1  @first digit (units place)
	mov r10,#0 @second digit
	mov r11,#0 @third digit
	mov r12,#0 @fourth digit
	mov r5,#0  @just iterates over outer loop

	mov r13,#0 @counter

outer:
	add r5, r5, #1 @increment the loop iterator
	
	mov r6,#100 @checking if iterator has reached 10000 or not
	mov r2,#100
	mul r8,r2,r6
	cmp r5, r8

	beq done    @ break if r5 is 10000
	mov r6, r9  @ create a copy of digits for manipulation
	mov r2, r10
	mov r3, r11
	mov r4, r12

	gtThan1:    @ this would continue until the sum of squares is a single digit number
		add r8, r2, r3 @ r8 here stores the sum of thousands, hundred and tens digit
		add r8, r8, r4 
		cmp r8,#0      @if this is 0, it means all the numbers were 0
		beq next       @the work here is over

		mov r7, #0 @stores the sum of squares
		mul r8, r6, r6 @r8 is just temporary holder
		add r7, r7, r8
		mul r8, r2, r2
		add r7, r7, r8
		mul r8, r3, r3
		add r7, r7, r8
		mul r8, r4, r4
		add r7, r7, r8

		mov r4,#0      @r4 would always be 0 as the largest sum of squares is 384

		mov r3,#0      @stores r3 appropriately
		cmp r7,#99
		movhi r3,#1
		cmp r7,#199
		movhi r3,#2
		mov r8,#100
		add r8,r8,#199
		cmp r7,r8
		movhi r3,#3

		mov r8, #100  @diminish the sum of squares here 
		mul r8, r3, r8
		sub r7, r7, r8

		mov r2, #0    @stores r2 appropriately
		cmp r7, #9
		movhi r2, #1
		cmp r7, #19
		movhi r2, #2
		cmp r7, #29
		movhi r2, #3
		cmp r7, #39
		movhi r2, #4
		cmp r7, #49
		movhi r2, #5
		cmp r7, #59
		movhi r2, #6
		cmp r7, #69
		movhi r2, #7
		cmp r7, #79
		movhi r2, #8
		cmp r7, #89
		movhi r2, #9

		mov r8, #10  @ again diminish
		mul r8, r2, r8
		sub r7, r7, r8

		mov r6, r7   @r6 would be the remaining sum of squares

		b gtThan1



	next:
		cmp r6,#1   @if r6 equals 1 or 7
		; addeq r0,r0,#1
		; do something if a happy number
		addeq r13, r13, #1
		beq Print
		
		cmp r6,#7
		addeq r13, r13, #1
		; addeq r0,r0,#1
		; do something if a happy number
		beq Print

incrementLoop:	
		cmp r9,#9   @set r9, r10, r11, r12 to next number
		addne r9,r9,#1
		bne outer
		mov r9,#0
		cmp r10,#9
		addne r10,r10,#1
		bne outer
		mov r10,#0
		cmp r11,#9
		addne r11,r11,#1
		bne outer
		mov r11,#0
		add r12,r12,#1
		b outer

Print:
		ldr r1, =infoMsg1
		swi SWI_PrStr
		ldr r1, =OutFileHandle
		str r0, [r1]
		mov r1, r13
		swi SWI_PrInt
		ldr r1, =infoMsg2
		swi SWI_PrStr
		ldr r1, =OutFileHandle
		str r0, [r1]
		mov r1, r12
		swi SWI_PrInt
		mov r1, r11
		swi SWI_PrInt
		mov r1, r10
		swi SWI_PrInt
		mov r1, r9
		swi SWI_PrInt
		ldr r1, =newLine
		swi SWI_PrStr
		b incrementLoop

done:
	ldr r0, =OutFileHandle
	ldr r0, [r0]
	swi SWI_Close
	swi SWI_Exit

OutFileHandle: .word 0
OutFileName: .asciz "output.txt"
errMsg: .asciz "File Not Found\n"
NoFileFound: 
	mov r0, #Stdout
	ldr r1, =errMsg
	swi SWI_PrStr

newLine: .asciz " \n"
infoMsg1: .asciz "number["
infoMsg2: .asciz "] = "


	.end