	seti r0, #0
	seti r1, #1
	invoke 1, 2, 3
	seti r4, #0
	seti r5, #0
	invoke 3, 4, 5
	invoke 4, 1, 0
	GOTO L1
L1:
	add r4, r4, r1
	GOTO_GE L2, R4, R2
	invoke 3, 4, 5
	invoke 4, 1, 0
	GOTO L1
L2:
	seti r4, #0
	add r5, r5, r1
	GOTO_GE L3, R5, R3
	invoke 3, 4, 5
	invoke 4, 1, 0
	GOTO L1
L3:
	stop