	.meta source "\"test53/cell.auto\""
	.meta fields "[{ \"name\": \"\", \"num\": 0, \"lo\": 0, \"hi\": 1 }]"
	invoke 1, 2, 3
	seti r4, #1
	seti r0, #0
L0:
	seti r1, #0
L1:
	invoke 3, 0, 1
	invoke 5, 13, 7
	seti r14, #1
	goto_ne L3, r13, r14
L2:
	seti r12, #1
	invoke 4, 12, 0
	goto L4
L3:
	invoke 5, 10, 8
	seti r11, #1
	goto_ne L6, r10, r11
L5:
	seti r9, #1
	invoke 4, 9, 0
	goto L7
L6:
	invoke 5, 7, 1
	seti r8, #1
	goto_ne L9, r7, r8
L8:
	seti r6, #1
	invoke 4, 6, 0
	goto L10
L9:
	seti r5, #0
	invoke 4, 5, 0
L10:
L7:
L4:
	add r1, r1, r4
	goto_lt L1, r1, r3
	add r0, r0, r4
	goto_lt L0, r0, r2
	stop
