.text
# Example program for the Duke 550 computer, by Tyler Bletsch (Tyler.Bletsch@duke.edu). 
# Developed for ECE 250, fall 2016.
#
# This program prints "Hello" just with immediate values

    # just print Hello and then loop forever
    addi $r1, $r0, 72  ;H
    output $r1
    addi $r1, $r0, 101 ;e
    output $r1
    addi $r1, $r0, 108 ;l
    output $r1
    addi $r1, $r0, 108 ;l
    output $r1
    addi $r1, $r0, 111 ;o
    output $r1
    beq $r0,$r0,-1 ; loop forever
