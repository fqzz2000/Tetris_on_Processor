.text
# Example program for the Duke 550 computer, by Tyler Bletsch (Tyler.Bletsch@duke.edu). 
# Developed for ECE 250, fall 2016.
#
# This program prints "Hello from dmem" from data memory.

    # just print Hello and then loop forever
    addi $r1, $r0, 0    ; start $r1 at the beginning of our string str
loop:
    lw $r2, 0($r1)      ; load char
    beq $r2, $r0, 3     ; skip to done if null
    output $r2          ; print char
    addi $r1, $r1, 1    ; ptr++
    beq $r0, $r0, -5    ; go back to loop (up 5 instructions, including this one)
done:   
    beq $r0,$r0,-1 ; loop forever

.data
; our assembler allows labels, but doesn't let you reference them, so just note that this label is at dmem address 0
str: .asciiz "Hello from dmem"