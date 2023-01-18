	invoke 1, 0, 1
	seti r6, #1
	seti r7, #0
	sub r0, r0, r6
	sub r1, r1, r6
	seti r2, #0
	sub r2, r2, r6
	seti r3, #0
	sub r3, r3, r6
	seti r4, #0
	seti r5, #1
L0:
	GOTO_GE L5, r3, r1
	add r3, r3, r6
	
	seti r2, #0
	sub r2, r2, r6
L1:
	GOTO_GE L0, r2, r0
	add r2, r2, r6
	invoke 3, 2, 3
	invoke 5, 5, 0
	GOTO_EQ L2, r5, r6
	GOTO_EQ L3, r5, r7
	GOTO L1
L2:
	invoke 4, 7, 0
	GOTO L1

L3:
	invoke 5, 5, 1
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 2
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 3
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 4
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 5
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 6
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 7
	GOTO_EQ L4, r5, r6
	invoke 5, 5, 8
	GOTO_EQ L4, r5, r6
	GOTO L1

L4:
	invoke 4, 6, 0
	GOTO L1

L5:
	stop