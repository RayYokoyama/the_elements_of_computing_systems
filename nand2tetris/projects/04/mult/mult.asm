// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
 @i    // A = i → 111 
 M=1   // i = 1, M[111] = 1
 @sum
 M=0   // sum = 0, M[sum] = 0
(LOOP)
 @i    // A = i
 D=M   // D = i, D = M[A]
 @100  // A = 100
 D=D-A // D = i - 100
 @END
 D;JGT
 @i
 D=M
 @sum
 M=D+M // sum = i + sum
 @i
 M=M+1 // i ++
 @LOOP
 0;JMP
(END)
 @END
 0;JMP
