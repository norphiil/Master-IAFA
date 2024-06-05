	.meta source "\"test53/multi.auto\""
	.meta fields "[{ \"name\": \"\", \"num\": 0, \"lo\": 0, \"hi\": 1 }]"
	invoke 1, 2, 3
	seti r4, #1
	seti r0, #0
L0:
	seti r1, #0
L1:
	invoke 3, 0, 1
	invoke 5, 26, 7
	seti r27, #1
	goto_ne L12, r26, r27
L11:
	seti r25, #1
	set r5, r25
	goto L13
L12:
	seti r24, #0
	set r5, r24
L13:
	invoke 5, 22, 8
	seti r23, #1
	goto_ne L9, r22, r23
L8:
	seti r21, #1
	set r6, r21
	goto L10
L9:
	seti r20, #0
	set r6, r20
L10:
	invoke 5, 18, 1
	seti r19, #1
	goto_ne L6, r18, r19
L5:
	seti r17, #1
	set r7, r17
	goto L7
L6:
	seti r16, #0
	set r7, r16
L7:
	set r10, r5
	set r11, r6
	add r12, r10, r11
	set r13, r7
	add r14, r12, r13
	seti r15, #0
	goto_eq L3, r14, r15
L2:
	seti r9, #1
	invoke 4, 9, 0
	goto L4
L3:
	seti r8, #0
	invoke 4, 8, 0
L4:
	add r1, r1, r4
	goto_lt L1, r1, r3
	add r0, r0, r4
	goto_lt L0, r0, r2
	stop
