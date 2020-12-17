(INPUT)
	@KBD
	D=M
	@FILL_WHITE
	D;JEQ 
	@FILL_BLACK
	0;JMP
@INPUT
0;JMP
(FILL_WHITE)
    // const SCREEN = 16384
    // let count = count
    // cont color = white
    // loop
    //  count++
    //  if (count + (512*256) - count === 0) end;
    //  arr[count] = white
    // end
    @color
	M=0
	@SCREEN
	D=A
	@count
	M=D // count = SCREEN
  @FILL_LOOP
  0;JMP
(FILL_BLACK)
    // const count = 16384
    // let count = count
    // cont color = black
    // loop
    //  count++
    //  if (count + (512*256) - count === 0) end;
    //  arr[count] = black
    // end
  @3
  D=A
  @color
  M=D
	@SCREEN
	D=A
	@count
	M=D // count = SCREEN
  @FILL_LOOP
  0;JMP
(FILL_LOOP)
  @color 
  D=M
  @count
  A=M
  M=D // MEM[count] = color
  @count
  M=M+1 // screnn += 1
  @24576 // SCREEN + (512*256) // SCREEN = 16384
  D=A
  @count
  D=D-M // D = 24576 - count
@FILL_LOOP
D;JGT // if D > 0 goto FILL_LOOP
@INPUT
0;JMP
