	.equ SWI_Exit, 0x11
	.equ SWI_CheckBlue, 0x203 
	.equ BLUE_0, 0x01     @button(0)
	.equ BLUE_1, 0x02     @button(1)
	.equ BLUE_2, 0x04     @button(2)
	.equ BLUE_3, 0x08     @button(3)
	.equ BLUE_4, 0x10     @button(4)
	.equ BLUE_5, 0x20     @button(5)
	.equ BLUE_6, 0x40     @button(6)
	.equ BLUE_7, 0x80     @button(7)
	.text

	
	ldr r11, =Board ;stores the Board
	mov r10, #0 @which player's turn
; Press button to start the game
	mov r0, #2
	mov r1, #7
	ldr r2, =Intro
	swi 0x204
	mov r0, #0
gameStart:
	swi 0x202
	cmp r0, #0
	beq gameStart
	swi 0x206

	mov r0, #16
	mov r1, #1
	ldr r2, =Othello
	swi 0x204

; This is the code to generate the grid
	mov r0, #9
	ldr r2, =Pipe
outerLoop:
	mov r1, #3
	add r0, r0, #2
	cmp r0, #29
	beq gridGenerated
	innerLoop:
		cmp r1, #11
		beq outerLoop
		swi 0x204
		add r1, r1, #1
		b innerLoop
gridGenerated:
	mov r0, #18 @marking the initial 0 and 1
	mov r1, #6
	mov r2, #1
	swi 0x205
	mov r0, #20
	mov r1, #7
	mov r2, #1
	swi 0x205
	mov r0, #18
	mov r1, #7
	mov r2, #0
	swi 0x205
	mov r0, #20
	mov r1, #6
	mov r2, #0
	swi 0x205
	@marking the helping indices
	mov r3, #-1
ind1:
	add r3, r3, #1
	cmp r3, #8
	moveq r3, #-1
	beq ind2
	add r0, r3, #12
	add r0, r0, r3
	mov r1, #2
	mov r2, r3
	swi 0x205
	b ind1
ind2:
	add r3, r3, #1
	cmp r3, #8
	beq newMove
	mov r0, #10
	add r1, r3, #3
	mov r2, r3
	swi 0x205
	b ind2


	
; Grid generated. All registers are available for use

; checking if possible to mov
newMove:
	bl printLCD
	@whose turn
	mov r0, #3
	mov r1, #12
	cmp r10, #0
	ldreq r2, =P0Turn
	ldrne r2, =P1Turn
	swi 0x204 
	bl canFlip@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	cmp r8, #0
	beq plCantFlip
	bne rowInput
	plCantFlip:
		rsb r10, r10, #1
		bl canFlip@ other player's checking
		cmp r8, #0
		beq done@THE GAME FINISHES HERE
		b newMove
; Taking row input
rowInput:
	mov r0, #0x02 @left LED on
	swi 0x201
	swi SWI_CheckBlue
	cmp r0, #0
	beq rowInput @if no input yet
	cmp r0, #BLUE_0
	moveq r3, #0 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_1
	moveq r3, #1 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_2
	moveq r3, #2 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_3
	moveq r3, #3 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_4
	moveq r3, #4 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_5
	moveq r3, #5 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_6
	moveq r3, #6 @STORES THE ROW
	beq colInput
	cmp r0, #BLUE_7
	moveq r3, #7 @STORES THE ROW
	beq colInput
	b rowInput @if something garbage was input
colInput:
	mov r0, #0x01 @left LED on
	swi 0x201
	swi SWI_CheckBlue
	cmp r0, #0
	beq colInput
	cmp r0, #BLUE_0
	moveq r4, #0 @ stores the column
	beq change
	cmp r0, #BLUE_1
	moveq r4, #1
	beq change
	cmp r0, #BLUE_2
	moveq r4, #2
	beq change
	cmp r0, #BLUE_3
	moveq r4, #3
	beq change
	cmp r0, #BLUE_4
	moveq r4, #4
	beq change
	cmp r0, #BLUE_5
	moveq r4, #5
	beq change
	cmp r0, #BLUE_6
	moveq r4, #6
	beq change
	cmp r0, #BLUE_7
	moveq r4, #7
	beq change
	b colInput
change:
	@checking if input is previously present there
	mov r5, r3, LSL #3 @r5 = r3*8
	add r6, r4, r5     @r6 = r4+r5
	ldrb r8, [r11, r6]
	cmp r8, #1
	beq rowInput
	cmp r8, #0
	beq rowInput

	mov r5, #0 @atishya asked for it
	b flip @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@print board onto lcd
printLCD:
		mov r4, #-1
		mov r5, #2 @constant 2
		mov r8, #8 @constant 8
		mov r6, #3
		mov r7, #12
		mov r9, #0 @p0 score
		mov r12, #0 @p1 score
	outerPrint:
		add r4, r4, #1
		mov r3, #-1
		cmp r4, #8
		bne innerPrint
		@the sets the current scores
		mov r0, #12 @line clear
		swi 0x208
		mov r0, #13
		swi 0x208
		mov r0, #25
		mov r1, #12
		ldr r2, =P0Score 
		swi 0x204
		mov r0, #25
		mov r1, #13
		ldr r2, =P1Score 
		swi 0x204
		mov r0, #33
		mov r1, #12
		mov r2, r9
		swi 0x205
		mov r0, #33
		mov r1, #13
		mov r2, r12
		swi 0x205
		mov pc, lr
		innerPrint:
			add r3, r3, #1
			cmp r3, #8
			beq outerPrint
			mla r0, r5, r3, r7
			add r1, r6, r4
			mla r2, r8, r4, r3
			ldrb r2, [r11, r2]
			cmp r2, #0
			addeq r9, r9, #1
			cmp r2, #1
			addeq r12, r12, #1
			cmp r2, #2
			beq tmp
			swi 0x205
			tmp:
			b innerPrint





@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ati code
@ r10 player, r8 return, r11 board
@ r3,r4,r5,r6,r7,r8,r9,r12
canFlip:
	mov r3, #0
	mov r5, #1
	OuterLoop:
	mov r4, #0
		InnerLoop:
			mov r8, #0
			b flip
canFlipCont:			
			cmp r8, #1
			beq EndCanFlip
			add r4, r4, #1
			cmp r4, #8		
		bne InnerLoop
	add r3, r3, #1
	cmp r3, #8
	bne OuterLoop
	mov r8, #0
EndCanFlip:
	mov pc, lr

flip: @ no change -> rowInput, change -> flip and player change then rowInput, r9 -> curr pos in linear array, r5 -> caller, 0 to flip
	mov r9, r3, LSL #3	@ Initial row and col of input
	add r9, r9, r4
	mov r12, #0		@ to keep count of no. of flips which will help to determine illegal move

	ldrb r8, [r11,r9]
	cmp r5, #1
	bne StartFlip
	cmp r8, #2
	beq StartFlip
	mov r8, #0
	b canFlipCont
	 	
StartFlip:	
	@ Checking on right

	mov r6, r4	@ r6 to maintain inner loop
	add r6, r6, #1
	mov r8, r9
	add r8, r8, #1
HoriAhead:
	cmp r6, #8
	beq EndHoriAhead
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertHoriAhead
	cmp r7, #2
	beq EndHoriAhead 
	add r6, r6, #1
	add r8, r8, #1
	cmp r6, #8
	bne HoriAhead
	b EndHoriAhead
InvertHoriAhead:
	sub r7, r8, r9
	cmp r7, #1
	bgt HoriAheadRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndHoriAhead
HoriAheadRetOrFlip:
	cmp r5, #1
	beq HoriAheadRet
	bne HoriAheadFlipIt
HoriAheadRet:
	mov r8, #1
	b canFlipCont
HoriAheadFlipIt:
	strb r10, [r11,r8]
	sub r8, r8, #1
	add r12, r12, #1
	cmp r8, r9
	bne HoriAheadFlipIt	
EndHoriAhead:

	@ Checking on left
		
	mov r6, r4	@ r6 to maintain inner loop
	sub r6, r6, #1
	mov r8, r9
	sub r8, r8, #1
HoriBack:
	cmp r6, #-1
	beq EndHoriBack
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertHoriBack
	cmp r7, #2
	beq EndHoriBack
	sub r6, r6, #1
	sub r8, r8, #1
	cmp r6, #-1
	bne HoriBack
	b EndHoriBack
InvertHoriBack:
	sub r7, r9, r8
	cmp r7, #1
	bgt HoriBackRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndHoriBack
HoriBackRetOrFlip:
	cmp r5, #1
	beq HoriBackRet
	bne HoriBackFlipIt
HoriBackRet:
	mov r8, #1
	b canFlipCont
HoriBackFlipIt:
	strb r10, [r11,r8]
	add r8, r8, #1
	add r12, r12, #1
	cmp r8, r9
	bne HoriBackFlipIt	
EndHoriBack:

	@ Checking vert up
		
	mov r6, r3	@ r6 to maintain inner loop
	sub r6, r6, #1
	mov r8, r9
	sub r8, r8, #8
VertUp:
	cmp r6, #-1
	beq EndVertUp
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertVertUp
	cmp r7, #2
	beq EndVertUp
	sub r6, r6, #1
	sub r8, r8, #8
	cmp r6, #-1
	bne VertUp
	b EndVertUp
InvertVertUp:
	sub r7, r9, r8
	cmp r7, #8
	bgt VertUpRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndVertUp
VertUpRetOrFlip:
	cmp r5, #1
	beq VertUpRet
	bne VertUpFlipIt
VertUpRet:
	mov r8, #1
	b canFlipCont
VertUpFlipIt:
	strb r10, [r11,r8]
	add r8, r8, #8
	add r12, r12, #1
	cmp r8, r9
	bne VertUpFlipIt	
EndVertUp:

	@ Checking vert down
		
	mov r6, r3	@ r6 to maintain inner loop
	add r6, r6, #1
	mov r8, r9
	add r8, r8, #8
VertDown:
	cmp r6, #8
	beq EndVertDown
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertVertDown
	cmp r7, #2
	beq EndVertDown
	add r6, r6, #1
	add r8, r8, #8
	cmp r6, #8
	bne VertDown
	b EndVertDown
InvertVertDown:
	sub r7, r8, r9
	cmp r7, #8
	bgt VertDownRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndVertDown
VertDownRetOrFlip:
	cmp r5, #1
	beq VertDownRet
	bne VertDownFlipIt
VertDownRet:
	mov r8, #1
	b canFlipCont
VertDownFlipIt:
	strb r10, [r11,r8]
	sub r8, r8, #8
	add r12, r12, #1
	cmp r8, r9
	bne VertDownFlipIt	
EndVertDown:

	@ Checking diag downRight
		
	cmp r3, r4
	movgt r6,r3 
	movle r6, r4	@ r6 to maintain inner loop
	add r6, r6, #1
	mov r8, r9
	add r8, r8, #9
DiagDownRight:
	cmp r6, #8
	beq EndDiagDownRight
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertDiagDownRight
	cmp r7, #2
	beq EndDiagDownRight	
	add r6, r6, #1
	add r8, r8, #9
	cmp r6, #8
	bne DiagDownRight
	b EndDiagDownRight
InvertDiagDownRight:
	sub r7, r8, r9
	cmp r7, #9
	bgt DiagDownRightRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndDiagDownRight
DiagDownRightRetOrFlip:
	cmp r5, #1
	beq DiagDownRightRet
	bne DiagDownRightFlipIt
DiagDownRightRet:
	mov r8, #1
	b canFlipCont
DiagDownRightFlipIt:
	strb r10, [r11,r8]
	sub r8, r8, #9
	add r12, r12, #1
	cmp r8, r9
	bne DiagDownRightFlipIt	
EndDiagDownRight:

	@ Checking diag upLeft
		
	cmp r3, r4
	movgt r6,r4 
	movle r6, r3	@ r6 to maintain inner loop
	sub r6, r6, #1
	mov r8, r9
	sub r8, r8, #9
DiagUpLeft:
	cmp r6, #-1
	beq EndDiagUpLeft
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertDiagUpLeft
	cmp r7, #2
	beq EndDiagUpLeft
	sub r6, r6, #1
	sub r8, r8, #9
	cmp r6, #-1
	bne DiagUpLeft
	b EndDiagUpLeft
InvertDiagUpLeft:
	sub r7, r9, r8
	cmp r7, #9
	bgt DiagUpLeftRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndDiagUpLeft
DiagUpLeftRetOrFlip:
	cmp r5, #1
	beq DiagUpLeftRet
	bne DiagUpLeftFlipIt
DiagUpLeftRet:
	mov r8, #1
	b canFlipCont
DiagUpLeftFlipIt:
	strb r10, [r11,r8]
	add r8, r8, #9
	add r12, r12, #1
	cmp r8, r9
	bne DiagUpLeftFlipIt	
EndDiagUpLeft:

	@ Checking diag downLeft
	
	rsb r3, r3, #7	
	cmp r3, r4
	movgt r6, r4 
	movle r6, r3	@ r6 to maintain inner loop
	rsb r3, r3, #7
	sub r6, r6, #1
	mov r8, r9
	add r8, r8, #7
DiagDownLeft:
	cmp r6, #-1
	beq EndDiagDownLeft
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertDiagDownLeft
	cmp r7, #2
	beq EndDiagDownLeft
	sub r6, r6, #1
	add r8, r8, #7
	cmp r6, #-1
	bne DiagDownLeft
	b EndDiagDownLeft
InvertDiagDownLeft:
	sub r7, r8, r9
	cmp r7, #7
	bgt DiagDownLeftRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndDiagDownLeft
DiagDownLeftRetOrFlip:
	cmp r5, #1
	beq DiagDownLeftRet
	bne DiagDownLeftFlipIt
DiagDownLeftRet:
	mov r8, #1
	b canFlipCont
DiagDownLeftFlipIt:
	strb r10, [r11,r8]
	sub r8, r8, #7
	add r12, r12, #1
	cmp r8, r9
	bne DiagDownLeftFlipIt	
EndDiagDownLeft:

	@ Checking diag upRight
	
	rsb r4, r4, #7	
	cmp r3, r4
	movgt r6, r4 
	movle r6, r3	@ r6 to maintain inner loop
	rsb r4, r4, #7
	sub r6, r6, #1
	mov r8, r9
	sub r8, r8, #7
DiagUpRight:
	cmp r6, #-1
	beq EndDiagUpRight
	ldrb r7, [r11,r8]
	cmp r7, r10
	beq InvertDiagUpRight
	cmp r7, #2
	beq EndDiagUpRight
	sub r6, r6, #1
	sub r8, r8, #7
	cmp r6, #-1
	bne DiagUpRight
	b EndDiagUpRight
InvertDiagUpRight:
	sub r7, r9, r8
	cmp r7, #7
	bgt DiagUpRightRetOrFlip
@ if r5 = 1 then we need to check in further functions for possible moves	
	b EndDiagUpRight
DiagUpRightRetOrFlip:
	cmp r5, #1
	beq DiagUpRightRet
	bne DiagUpRightFlipIt
DiagUpRightRet:
	mov r8, #1
	b canFlipCont
DiagUpRightFlipIt:
	strb r10, [r11,r8]
	add r8, r8, #7
	add r12, r12, #1
	cmp r8, r9
	bne DiagUpRightFlipIt	
EndDiagUpRight:

cmp r5, #1
moveq r8, #0
beq canFlipCont
cmp r12, #0
beq rowInput
strb r10, [r11,r9]
rsb r10, r10, #1
b newMove
EndFlip:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2

done:
	mov r0, #0x03
	swi 0x201 @light up the two LEDs
	mov r3, #-1
	mov r8, #8 @constant 8
	mov r9, #0 @p0 count
	mov r12, #0 @p1 count

outerLoopCount:
	add r3, r3, #1
	cmp r3, #8
	beq exit
	mov r4, #-1
	innerLoopCount:
		add r4, r4, #1
		cmp r4, #8
		beq outerLoopCount
		mla r2, r8, r3, r4
		ldrb r2, [r11,r2]
		cmp r2, #0
		addeq r9, r9, #1
		cmp r2, #1
		addeq r12, r12, #1
		b innerLoopCount


exit:	
	mov r0, #3
	mov r1, #12
	cmp r9,r12
	ldreq r2, =Draw
	ldrgt r2, =P0Win
	ldrlt r2, =P1Win
	swi 0x204
	swi SWI_Exit

	.data
	Board: .byte 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0, 2, 2, 2, 2, 2, 2, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
	Pipe: .asciz "|\n"
	Empty: .asciz " \n"
	Intro: .asciz "Press black button to start the game\n"
	Othello: .asciz "Othello\n"
	P0Score: .asciz "Player0: "
	P1Score: .asciz "Player1: "
	P0Turn: .asciz "Player0's turn"
	P1Turn: .asciz "Player1's turn"
	P0Win: .asciz "Player0 is the winner"
	P1Win: .asciz "Player1 is the winner"
	Draw: .asciz "The game is a draw"
	.end