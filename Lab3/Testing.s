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