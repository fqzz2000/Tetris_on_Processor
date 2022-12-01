.text
# Example program for the Duke 550 computer, by Tyler Bletsch (Tyler.Bletsch@duke.edu). 
# Developed for ECE 250, fall 2016.
#
# This program print "Echo:", then echos the keyboard forever

# print "Echo: "
    addi $r1, $r0, 69   ;E
    output $r1
    addi $r1, $r0, 99   ;c
    output $r1
    addi $r1, $r0, 104  ;h
    output $r1
    addi $r1, $r0, 111  ;o
    output $r1
    addi $r1, $r0, 58   ;:
    output $r1
    
# echo forever
loop:
    input $r1
    output $r1
    beq $r0,$r0,-3 ; branch back to loop
