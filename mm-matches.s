@ This ARM Assembler code should implement a matching function, for use in the MasterMind program, as
@ described in the CW2 specification. It should produce as output 2 numbers, the first for the
@ exact matches (peg of right colour and in right position) and approximate matches (peg of right
@ color but not in right position). Make sure to count each peg just once!
	
@ Example (first sequence is secret, second sequence is guess):
@ 1 2 1
@ 3 1 3 ==> 0 1
@ You can return the result as a pointer to two numbers, or two values
@ encoded within one number
@
@ -----------------------------------------------------------------------------

.text
@ this is the matching fct that should be called from the C part of the CW	
.global matches
.global showseq
@ use the name `main` here, for standalone testing of the assembler code
@ when integrating this code into `master-mind.c`, choose a different name
@ otw there will be a clash with the main function in the C code
@.global         main
@main: 
@	LDR  R2, =secret	@ pointer to secret sequence
@	LDR  R3, =guess		@ pointer to guess sequence

	@ you probably need to initialise more values here

	@ ... COMPLETE THE CODE BY ADDING YOUR CODE HERE, you should use sub-routines to structure your code

@exit:	@MOV	 R0, R4		@ load result to output register
@	MOV 	 R7, #1		@ load system call code
@	SWI 	 0		@ return this value

@ -----------------------------------------------------------------------------
@ sub-routines

@ this is the matching fct that should be callable from C	
matches:			@ Input: R0, R1 ... ptr to int arrays to match ; Output: R0 ... exact matches (10s) and approx matches (1s) of base COLORS
	PUSH {LR}
	LDR R7, = placement
	MOV R2, #0 
	MOV R3, #0 
	MOV R4, #0 
	B spotLoop
	
	
spotLoop:
	LDR R5, [R0, +R4]
	LDR R6, [R1, +R4]
	
	CMP R5,R6
	BEQ spot
	
	ADD R4, R4, #4
	CMP R4, #12
	BEQ end
	B spotLoop

spot: 
	ADD R2, R2, #1
	MOV R5, #1
	STR R5, [R7, +R4]
	ADD R4, R4, #4
	CMP R4, #12
	BEQ end
	B spotLoop
end:
    LDR R6, =result
	STR R2, [R6]
	MOV R4, #0 @ reset 
	MOV R3, #0
	B outerLoop
	
	
outerLoop:
	LDR R2, [R7, +R4]
	CMP R2, #1
	BEQ continue
	
	MOV R2, #0
	BL innerLoop
	ADD R4, R4, #4
	CMP R4, #12
	BGE final
	B outerLoop

continue:
	ADD R4, R4, #4
	CMP R4, #12
	BGE final
	B outerLoop
	
innerLoop:
	LDR R5, [R7, +R2]
	CMP R5, #1
	BEQ continueInner
	LDR R5, [R0, +R4] 
	LDR R6, [R1, +R2] 
	CMP R5, R6
	BEQ close
	ADD R2, R2, #4
	CMP R2, #12
	BLE innerLoop
	BX LR

close: 
	ADD R3, R3, #1
	B continue
	
continueInner:
	ADD R2, R2, #4
	CMP R2, #12
	BLE innerLoop
	BX LR
	
final: 
	LDR R0, =result
	LDR R1, [R0]
	MOV R4, #10
	MUL R1, R1, R4
	ADD R0, R1, R3
	POP {PC}
	
	

@ show the sequence in R0, use a call to printf in libc to do the printing, a useful function when debugging 
showseq: 			@ Input: R0 = pointer to a sequence of 3 int values to show
	@ COMPLETE THE CODE HERE (OPTIONAL)
	PUSH {LR}
	MOV R4, R0
	LDR R0, =f4str
	LDR R1, [R4]
	LDR R2, [R4, #4]
	LDR R3, [R4, #8]
	BL printf
	POP {PC}
	
@ =============================================================================

.data

@ constants about the basic setup of the game: length of sequence and number of colors	
@ .equ LEN, 3
@ .equ COL, 3
@ .equ NAN1, 8
@ .equ NAN2, 9

@ a format string for printf that can be used in showseq
f4str: .asciz "Seq:    %d %d %d\n"

@ a memory location, initialised as 0, you may need this in the matching fct
@ n: .word 0x00
	
@ INPUT DATA for the matching function
result: .word 0

.align 4
placement: .word 0
	.word 0
	.word 0 

.align 4
secret: .word 1 
	.word 2 
	.word 1 

.align 4
guess:	.word 3 
	.word 1 
	.word 3 


