/******************************************************************************
* @file array.s
* @brief simple array declaration and iteration example
*
* Simple example of declaring a fixed-width array and traversing over the
* elements for printing.
*
* @author Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
    BL _seedrand            @ seed random number generator with current time
    MOV R0, #0              @ initialze index variable
writeloop:
    CMP R0, #100            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _getrand             @ get a random number
    POP {R2}                @ restore element address
	LSR R0, R0, #22
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
	MOV R7, #250				@ MIN
	LSL R7, R7, #2
	MOV R8, #0				@ MAX
readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset	POSITION OF ELEMENT X
    ADD R2, R1, R2          @ R2 now has the element address	R1 = START ADDRESS OF ARRAY || R2 = ARRAY POSITION: 4, 8,  12, ETC
    LDR R1, [R2]            @ read the array at address
	CMPLT R8, R1		@ COMPARE R1 GREATER THAN R6
	MOVLT R8, R1		@ MOVE R1 TO R6
	CMPGT R7, R1		@ COMPARE R1 LESS THAN R6
	MOVGT R7, R1		@ MOVE R1 TO R7
    PUSH {R0}               @ backup register before printf	INDEX
    PUSH {R1}               @ backup register before printf	VALUE
    PUSH {R2}               @ backup register before printf	ADDRESS
    MOV R2, R1              @ move array value to R2 for printf	VALUE -> R2
    MOV R1, R0              @ move array index to R1 for printf	INDEX -> R1
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
	BL _printENDS
    B _exit                 @ exit if done
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf:
    PUSH {LR}               @ store the return address
@	MOV R3, R6			@MOVE R6 GREATER VALUE TO R2
@	MOV R4, R7
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printENDS:
    PUSH {LR}               @ store the return address
	MOV R1, R7			@MOVE R6 GREATER VALUE TO R2
	MOV R2, R8
    LDR R0, =ENDS     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return 
    
_getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    POP {PC}                @ return 
   
.data

.balign 4
a:              .skip       400
printf_str:     .asciz      "a[%d] = %d\n"
ENDS:	.asciz			"MINIMUM VALUE = %d\nMAXIMUM VALUE = %d\n"
exit_str:       .ascii      "Terminating program.\n"
