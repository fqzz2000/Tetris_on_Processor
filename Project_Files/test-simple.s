.text
# Example program for the Duke 550 computer, by Tyler Bletsch (Tyler.Bletsch@duke.edu). 
# Developed for ECE 250, fall 2016.
#
# This program doesn't output anything; it mainly just plays with various instructions, and is suitable for simulation

    # load address of string and run the print string function
    addi $r1, $r0, 0            # r1 = address of hello
    jal 16                      # call puts function, r31=PC+1 (0x0008)

    # read a byte and the word kappa and subtract
    input $r5                # r5 = the key or 256 on fail
    addi $r1, $r0, 7         # r1 = address of kappa (7)
    lw $r2, 0($r1)           # r2 = kappa           (1000 or 0x03E8)
    sub $r3, $r2, $r5        # r3 = kappa - key     (744 or 0x2E8 if read was a failure)

    # do some random instructions
    or $r5, $r2, $r0         # r5 = kappa | 0  (logically, this must be kappa itself)
    addi $r20, $r0, 2        # r20 = 2
    sll $r6, $r2, $r20       # r6 = kappa << 2      (4000 or 0x0FA0)
    srl $r6, $r2, $r20       # r6 = kappa >> 2      (250 or 0x00FA)
    addi $r2, $r2, -2        # r2 -= 2              (998 or 0x03E6)
    addi $r20, $r0, 1        # r20 = 1
    srl $r2, $r2, $r20       # r2 >>= 1             (499 or 0x01F3)
    bgt $r2, $r0, 1          # if (r2>=0) goto done (branch is taken)
    add $r2, $r2, $r0        # (this instruction is skipped)
    
done:
    # end the program -- this will hang forever
    beq $r0, $r0, -1
    
    # registers at end of program (assuming read was a fail): [0000 0007 01F3 02E8 0000 01F3 00FA 0002 others...]

puts:
loop:
    lw $r3, 0($r1)        # load this character (because we're in word-addressed memory, each character is a 16-bit word)
    beq $r3, $r0, 3       # if at null char, break
    output $r3            # print it
    addi $r1, $r1, 1      # pointer++
    j 16                  # loop
endloop:
    jr $r31               # return

.data
hello: .asciiz "Hello!"
kappa: .word 1000
