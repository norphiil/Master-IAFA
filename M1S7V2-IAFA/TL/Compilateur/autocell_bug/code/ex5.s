	seti r0, #0
	seti r1, #1
	invoke 1, 2, 3
	seti r4, #0
	seti r5, #0
	seti r6, #0
	GOTO L3
L0:
	stop
L1:
	add r4, r4, r1
	GOTO_GE L2, R4, R2
	GOTO L3
L2:
	seti r4, #0
	add r5, r5, r1
	GOTO_GE L0, R5, R3
	GOTO L3
L3:
	invoke 3, 4, 5
	invoke 5, 6, 0
	GOTO_EQ L4, R6, R0
	invoke 4, 0, 0
	GOTO L1
L4:
	invoke 5, 6, 1
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 2
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 3
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 4
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 5
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 6
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 7
	GOTO_EQ L5, R6, R1
	invoke 5, 6, 8
	GOTO_EQ L5, R6, R1
	GOTO L1
L5:
	invoke 4, 1, 0
	GOTO L1
