	invoke 1, 0, 1
	sub r0, r0, r4
	sub r1, r1, r4
	seti r2, #0
	seti r3, #0
	seti r4, #1
	invoke 3, 2, 3
	invoke 4, 4, 0
	add r2, r0, r2
	invoke 3, 2, 3
	invoke 4, 4, 0
	add r3, r1, r3
	invoke 3, 2, 3
	invoke 4, 4, 0
	sub r2, r0, r2
	invoke 3, 2, 3
	invoke 4, 4, 0
	stop