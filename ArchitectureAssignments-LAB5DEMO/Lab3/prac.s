	.equ SWI_Exit, 0x11
	.text

	
	ldr r11, =Board ;stores the Board
	



done:
	swi SWI_Exit

	.data
	Board: .byte 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0, 2, 2, 2, 2, 2, 2, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
	Pipe: .asciz "|\n"
	Intro: .asciz "Press black button to start the game\n"
	.end