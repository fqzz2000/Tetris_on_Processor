# "Fibonacci" test program
# Asks a user for a number N, then prints the N-th fibonacci number. Computes recursively, so may have memory issues for N>30 or so.
# Author unknown
# Disassembled by Tyler Bletsch for Duke ECE550, Fall 2016
#
# This test program was just available to me as hex, with the original author and means of creation lost to history.
# It has been disassembled below, with jumps annotated as comments.
# Having an undocumented binary file and needing to reverse-engineer it is not an uncommon problem in industry...
#

.text
L00000000: addi $r5, $r0, 32768
L00000001: addi $r5, $r5, -2
L00000002: addi $r1, $r0, 0
L00000003: jal 66                         # to L00000042
L00000004: jal 20                         # to L00000014
L00000005: sw $r3, 1($r5)
L00000006: lw $r1, 1($r5)
L00000007: jal 46                         # to L0000002e
L00000008: sw $r2, 0($r5)
L00000009: addi $r1, $r0, 11
L0000000a: jal 66                         # to L00000042
L0000000b: lw $r1, 1($r5)
L0000000c: jal 94                         # to L0000005e
L0000000d: addi $r1, $r0, 16
L0000000e: jal 66                         # to L00000042
L0000000f: lw $r1, 0($r5)
L00000010: jal 94                         # to L0000005e
L00000011: addi $r2, $r0, 13
L00000012: output $r2
L00000013: j 19                           # to L00000013
L00000014: addi $r2, $r0, 48
L00000015: addi $r3, $r0, 0
L00000016: input $r1
L00000017: addi $r4, $r0, 2
L00000018: addi $r6, $r0, 7
L00000019: sll $r4, $r4, $r6
L0000001a: and $r4, $r4, $r1
L0000001b: beq $r4, $r0, 1
L0000001c: j 22                           # to L00000016
L0000001d: output $r1
L0000001e: addi $r4, $r0, 10
L0000001f: beq $r1, $r4, 1
L00000020: j 34                           # to L00000022
L00000021: jr $r31
L00000022: addi $r4, $r0, 13
L00000023: beq $r1, $r4, 1
L00000024: j 38                           # to L00000026
L00000025: jr $r31
L00000026: addi $r6, $r0, 3
L00000027: sll $r4, $r3, $r6
L00000028: add $r4, $r4, $r3
L00000029: add $r4, $r4, $r3
L0000002a: add $r3, $r4, $r0
L0000002b: sub $r1, $r1, $r2
L0000002c: add $r3, $r3, $r1
L0000002d: j 22                           # to L00000016
L0000002e: addi $r5, $r5, -3
L0000002f: sw $r31, 2($r5)
L00000030: addi $r4, $r0, 2
L00000031: bgt $r4, $r1, 12
L00000032: sw $r1, 1($r5)
L00000033: addi $r1, $r1, -2
L00000034: jal 46                         # to L0000002e
L00000035: sw $r2, 0($r5)
L00000036: lw $r1, 1($r5)
L00000037: addi $r1, $r1, -1
L00000038: jal 46                         # to L0000002e
L00000039: lw $r3, 0($r5)
L0000003a: add $r2, $r2, $r3
L0000003b: lw $r31, 2($r5)
L0000003c: addi $r5, $r5, 3
L0000003d: jr $r31
L0000003e: add $r2, $r1, $r0
L0000003f: lw $r31, 2($r5)
L00000040: addi $r5, $r5, 3
L00000041: jr $r31
L00000042: addi $r3, $r0, 1
L00000043: lw $r2, 0($r1)
L00000044: beq $r2, $r0, 1
L00000045: j 71                           # to L00000047
L00000046: jr $r31
L00000047: add $r1, $r1, $r3
L00000048: output $r2
L00000049: j 67                           # to L00000043
L0000004a: addi $r4, $r0, 0
L0000004b: addi $r2, $r0, 10
L0000004c: addi $r6, $r0, 27
L0000004d: sll $r2, $r2, $r6
L0000004e: addi $r3, $r0, 5
L0000004f: beq $r2, $r3, 13
L00000050: j 81                           # to L00000051
L00000051: sub $r3, $r1, $r2
L00000052: bgt $r0, $r3, 6
L00000053: sub $r1, $r1, $r2
L00000054: addi $r6, $r0, 1
L00000055: sll $r4, $r4, $r6
L00000056: addi $r4, $r4, 1
L00000057: srl $r2, $r2, $r6
L00000058: j 78                           # to L0000004e
L00000059: addi $r6, $r0, 1
L0000005a: sll $r4, $r4, $r6
L0000005b: srl $r2, $r2, $r6
L0000005c: j 78                           # to L0000004e
L0000005d: jr $r31
L0000005e: addi $r5, $r5, -2
L0000005f: addi $r3, $r0, -1
L00000060: sw $r3, 0($r5)
L00000061: sw $r31, 1($r5)
L00000062: jal 74                         # to L0000004a
L00000063: addi $r5, $r5, -1
L00000064: sw $r1, 0($r5)
L00000065: add $r1, $r4, $r0
L00000066: beq $r1, $r0, 1
L00000067: j 98                           # to L00000062
L00000068: addi $r2, $r0, 48
L00000069: lw $r1, 0($r5)
L0000006a: addi $r5, $r5, 1
L0000006b: addi $r3, $r0, -1
L0000006c: beq $r1, $r3, 1
L0000006d: j 113                          # to L00000071
L0000006e: lw $r31, 0($r5)
L0000006f: addi $r5, $r5, 1
L00000070: jr $r31
L00000071: add $r1, $r1, $r2
L00000072: output $r1
L00000073: j 105                          # to L00000069
L00000074: add $r0, $r0, $r0
# More instructions with value 00000000 omitted...
.data
D00000000: .word 71
D00000001: .word 105
D00000002: .word 118
D00000003: .word 101
D00000004: .word 32
D00000005: .word 109
D00000006: .word 101
D00000007: .word 32
D00000008: .word 110
D00000009: .word 58
D0000000a: .word 0
D0000000b: .word 102
D0000000c: .word 105
D0000000d: .word 98
D0000000e: .word 40
D0000000f: .word 0
D00000010: .word 41
D00000011: .word 32
D00000012: .word 61
D00000013: .word 32
D00000014: .word 0
# More words with value 00000000 omitted...
