@256
D=A
@SP
M=D
@return-Sys.init
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@5
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.init
0;JMP
(return-Sys.init)
(Main.fibonacci)
@0
D=A
@ARG
A=M
A=A+D
D=M
@SP
A=M
M=D
@SP
M=M+1
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
AM=M-1
D=M
A=A-1
D=M-D
M=-1
@LTEND
D;JLT
@SP
A=M-1
M=0
(LTEND)
@SP
AM=M-1
D=M
@IF_TRUE
D;JNE
@IF_FALSE
0;JMP
(IF_TRUE)
@0
D=A
@ARG
A=M
A=A+D
D=M
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@13
M=D
@13
D=M
@5
A=D-A
D=M
@14
M=D
@0
D=A
@ARG
D=M+D
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@0
D=A
@ARG
M=M-D
@ARG
D=M+1
@SP
M=D
@13
A=M-1
D=M
@THAT
M=D
@13
D=M
@2
A=D-A
D=M
@THIS
M=D
@13
D=M
@3
A=D-A
D=M
@ARG
M=D
@13
D=M
@4
A=D-A
D=M
@LCL
M=D
@14
A=M
0;JMP
(IF_FALSE)
@0
D=A
@ARG
A=M
A=A+D
D=M
@SP
A=M
M=D
@SP
M=M+1
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
AM=M-1
D=M
A=A-1
M=M-D
@return-Main.fibonacci
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(return-Main.fibonacci)
@0
D=A
@ARG
A=M
A=A+D
D=M
@SP
A=M
M=D
@SP
M=M+1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
AM=M-1
D=M
A=A-1
M=M-D
@return-Main.fibonacci
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(return-Main.fibonacci)
@SP
AM=M-1
D=M
A=A-1
M=M+D
@LCL
D=M
@13
M=D
@13
D=M
@5
A=D-A
D=M
@14
M=D
@0
D=A
@ARG
D=M+D
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@0
D=A
@ARG
M=M-D
@ARG
D=M+1
@SP
M=D
@13
A=M-1
D=M
@THAT
M=D
@13
D=M
@2
A=D-A
D=M
@THIS
M=D
@13
D=M
@3
A=D-A
D=M
@ARG
M=D
@13
D=M
@4
A=D-A
D=M
@LCL
M=D
@14
A=M
0;JMP
(Sys.init)
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
@return-Main.fibonacci
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(return-Main.fibonacci)
(WHILE)
@WHILE
0;JMP
