# "Give me N" test program
# Asks a user for a number, then prints that number.
# Author unknown
# Disassembled by Tyler Bletsch for Duke ECE550, Fall 2016
#
# This test program was just available to me as hex, with the original author and means of creation lost to history.
# It has been disassembled below, with jumps annotated as comments.
# Having an undocumented binary file and needing to reverse-engineer it is not an uncommon problem in industry...
#

.text
L00000000: addi $r5, $r0, 32768
L00000001: addi $r1, $r0, 0
L00000002: jal 42                         # to L0000002a
L00000003: jal 16                         # to L00000010
L00000004: addi $r1, $r0, 1
L00000005: sub $r5, $r5, $r1
L00000006: sw $r3, 0($r5)
L00000007: addi $r1, $r0, 11
L00000008: jal 42                         # to L0000002a
L00000009: lw $r1, 0($r5)
L0000000a: addi $r2, $r0, 1
L0000000b: add $r5, $r5, $r2
L0000000c: jal 70                         # to L00000046
L0000000d: addi $r2, $r0, 13
L0000000e: output $r2
L0000000f: j 15                           # to L0000000f
L00000010: addi $r2, $r0, 48
L00000011: addi $r3, $r0, 0
L00000012: input $r1
L00000013: addi $r4, $r0, 2
L00000014: addi $r6, $r0, 7
L00000015: sll $r4, $r4, $r6
L00000016: and $r4, $r4, $r1
L00000017: beq $r4, $r0, 1
L00000018: j 18                           # to L00000012
L00000019: output $r1
L0000001a: addi $r4, $r0, 10
L0000001b: beq $r1, $r4, 1
L0000001c: j 30                           # to L0000001e
L0000001d: jr $r31
L0000001e: addi $r4, $r0, 13
L0000001f: beq $r1, $r4, 1
L00000020: j 34                           # to L00000022
L00000021: jr $r31
L00000022: addi $r6, $r0, 3
L00000023: sll $r4, $r3, $r6
L00000024: add $r4, $r4, $r3
L00000025: add $r4, $r4, $r3
L00000026: add $r3, $r4, $r0
L00000027: sub $r1, $r1, $r2
L00000028: add $r3, $r3, $r1
L00000029: j 18                           # to L00000012
L0000002a: addi $r3, $r0, 1
L0000002b: lw $r2, 0($r1)
L0000002c: beq $r2, $r0, 1
L0000002d: j 47                           # to L0000002f
L0000002e: jr $r31
L0000002f: add $r1, $r1, $r3
L00000030: output $r2
L00000031: j 43                           # to L0000002b
L00000032: addi $r4, $r0, 0
L00000033: addi $r2, $r0, 10
L00000034: addi $r6, $r0, 27
L00000035: sll $r2, $r2, $r6
L00000036: addi $r3, $r0, 5
L00000037: beq $r2, $r3, 13
L00000038: j 57                           # to L00000039
L00000039: sub $r3, $r1, $r2
L0000003a: bgt $r0, $r3, 6
L0000003b: sub $r1, $r1, $r2
L0000003c: addi $r6, $r0, 1
L0000003d: sll $r4, $r4, $r6
L0000003e: addi $r4, $r4, 1
L0000003f: srl $r2, $r2, $r6
L00000040: j 54                           # to L00000036
L00000041: addi $r6, $r0, 1
L00000042: sll $r4, $r4, $r6
L00000043: srl $r2, $r2, $r6
L00000044: j 54                           # to L00000036
L00000045: jr $r31
L00000046: addi $r5, $r5, -2
L00000047: addi $r3, $r0, -1
L00000048: sw $r3, 0($r5)
L00000049: sw $r31, 1($r5)
L0000004a: addi $r4, $r0, 1
L0000004b: jal 50                         # to L00000032
L0000004c: addi $r5, $r5, -1
L0000004d: sw $r1, 0($r5)
L0000004e: add $r1, $r4, $r0
L0000004f: beq $r1, $r0, 1
L00000050: j 75                           # to L0000004b
L00000051: addi $r2, $r0, 48
L00000052: addi $r4, $r0, 1
L00000053: lw $r1, 0($r5)
L00000054: addi $r5, $r5, 1
L00000055: addi $r3, $r0, -1
L00000056: beq $r1, $r3, 1
L00000057: j 91                           # to L0000005b
L00000058: lw $r31, 0($r5)
L00000059: addi $r5, $r5, 1
L0000005a: jr $r31
L0000005b: add $r1, $r1, $r2
L0000005c: output $r1
L0000005d: j 83                           # to L00000053
L0000005e: add $r0, $r0, $r0
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
D0000000b: .word 110
D0000000c: .word 32
D0000000d: .word 61
D0000000e: .word 32
D0000000f: .word 0
# More words with value 00000000 omitted...
