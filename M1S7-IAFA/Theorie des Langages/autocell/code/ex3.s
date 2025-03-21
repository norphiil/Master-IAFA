	invoke 1, 0, 1
	seti r6, #1
	sub r0, r0, r6
	sub r1, r1, r6
	seti r2, #0
	sub r2, r2, r6
	seti r3, #0
	sub r3, r3, r6
	seti r4, #0
	seti r5, #1
L0:
	GOTO_GE L3, r3, r1
	add r3, r3, r6
	
	seti r2, #0
	sub r2, r2, r6
L1:
	GOTO_GE L0, r2, r0
	add r2, r2, r6
	invoke 3, 2, 3
	invoke 5, 5, 3
	invoke 4, 6, 0
	GOTO L1
L3:
	stop