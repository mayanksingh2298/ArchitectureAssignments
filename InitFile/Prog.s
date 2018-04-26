mov r2, #0
ldr r1, [r2, #4000]
; mov r14, #22

mov r6, #0
mov r7, #0

mov r9, #1000
mov r10, #100
mov r11, #10
mov r12, #1

cmp r1, r9
subgt r1, r1, r9
movgt r5, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r10
subgt r1, r1, r10
addgt r6, r6, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7,r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
cmp r1, r11
subgt r1, r1, r11
addgt r7, r7, r12
mov r8, r1

mov r8, r8, LSL #28
mov r14, r8, LSR #28
mov r7, r7, LSL #28
orr r14, r14, r7, LSR #24
mov r6, r6, LSL #28
orr r14, r14, r6, LSR #20
mov r5, r5, LSL #28
orr r14, r14, r5, LSR #16

; memory_initialization_radix=16;
; memory_initialization_vector=e3a00000, e3a02000, e5921fa0, e3a06000,e3a07000,e3a09ffa,e3a0a064,e3a0b00a,e3a0c001,e1510009,c0411009,c1a0500c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000a,c041100a,c086600c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e151000b,c041100b,c087700c,e1a08001, e1a08001, e1a0ee28, e1a07e07, e18eec27, e1a06e06, e18eea26, e1a05e05, e18ee825;
