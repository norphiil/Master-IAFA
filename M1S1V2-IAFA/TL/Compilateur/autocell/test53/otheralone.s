	.meta source "\"test53/otheralone.auto\""
	.meta fields "[{ \"name\": \"\", \"num\": 0, \"lo\": 0, \"hi\": 1 }]"
	invoke 1, 2, 3
	seti r4, #1
	seti r0, #0
L0:
	seti r1, #0
L1:
	invoke 3, 0, 1
	seti r16, #0
	set r5, r16
	invoke 5, 14, 7
	seti r15, #1
	goto_ne L9, r14, r15
L8:
	seti r13, #1
	set r5, r13
	goto L10
L9:
L10:
	invoke 5, 11, 8
	seti r12, #1
	goto_ne L6, r11, r12
L5:
	seti r10, #1
	set r5, r10
	goto L7
L6:
L7:
	invoke 5, 8, 1
	seti r9, #1
	goto_ne L3, r8, r9
L2:
	seti r7, #1
	set r5, r7
	goto L4
L3:
L4:
	set r6, r5
	invoke 4, 6, 0
	add r1, r1, r4
	goto_lt L1, r1, r3
	add r0, r0, r4
	goto_lt L0, r0, r2
	stop
