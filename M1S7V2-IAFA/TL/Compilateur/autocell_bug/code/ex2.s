	seti r0, #0
	seti r1, #1
	invoke 1, 2, 3
	seti r4, #0
	seti r5, #0
	invoke 3, 4, 5
	invoke 4, 1, 0
	add r4, r4, r2
	sub r4, r4, r1
	invoke 3, 4, 5
	invoke 4, 1, 0
	add r5, r5, r3
	sub r5, r5, r1
	invoke 3, 4, 5
	invoke 4, 1, 0
	sub r4, r4, r2
	add r4, r4, r1
	invoke 3, 4, 5
	invoke 4, 1, 0
	stop