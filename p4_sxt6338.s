.global main
.func main

main:
	MOV R0, #0		@ initialize R0 with 0
	B _array

_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_array:
    CMP R0, #10            @ check to see if we are done iterating
	MOVEQ R0, #0			@	 initialize R0 to 0
    BEQ _printarray           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _scanf             @ get USER INPUT
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of R0 to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   _array           @ branch to next loop iteration

_printarray:
    CMP R0, #10           @ check to see if we are done iterating
    BEQ _prompt            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset	POSITION OF ELEMENT X
    ADD R2, R1, R2          @ R2 now has the element address	R1 = START ADDRESS OF ARRAY || R2 = ARRAY POSITION: 4, 8,  12, ETC
    LDR R1, [R2]            @ read the array at address
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
    B   _printarray            @ branch to next loop iteration

_prompt:
@	PUSH {LR}                 @ store LR since scanf call overwrites
    SUB SP, SP, #4        @ make room on stack
    LDR R0, =prompt     @ R0 contains formatted string address
    BL printf               		@ call printf
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                		@ call scanf
    LDR R0, [SP]            	@ load value at SP into R0
    ADD SP, SP, #4        @ restore the stack pointer
	MOV R3, R0				@ move scanf value to R3 for input argument to search
	MOV R0, #0				@ move 0 to R0 for search iteration
	MOV R4, #0				@ pretty sure this is bad coding practice, R4 is set to false
	B _search
@	POP {PC}                 	@ return

_search:
	CMP R0, #10           @ check to see if we are done iterating
	MOVEQ R0, R4			@ move bool to R0
	BEQ _bool            @ go to bool check if done
	LDR R1, =a              @ get address of a
	LSL R2, R0, #2          @ multiply index*4 to get array offset	POSITION OF ELEMENT X
	ADD R2, R1, R2          @ R2 now has the element address	R1 = START ADDRESS OF ARRAY || R2 = ARRAY POSITION: 4, 8,  12, ETC
	LDR R1, [R2]            @ read the array at address
	CMP R3, R1				@ compare the value of scanf in R3 to the current array value in R1
	MOVEQ R4, #1			@ if a match is found, indicate so with some value (like c code bool)
	PUSHEQ {R0}               @ backup register before printf	INDEX
	PUSHEQ {R1}               @ backup register before printf	VALUE
	PUSHEQ {R2}               @ backup register before printf	ADDRESS
	PUSHEQ {R3}				@ backup register before printf	SEARCH VALUE
	PUSHEQ {R4}				@ backup register before printf	BOOL
	MOVEQ R2, R1              @ move array value to R2 for printf	VALUE -> R2
	MOVEQ R1, R0              @ move array index to R1 for printf	INDEX -> R1
	BLEQ  _printf             @ branch to print procedure with return
	POPEQ {R4}				@restore BOOL
	POPEQ {R3}				@ restore SEARCH VALUE
	POPEQ {R2}                @ restore ADDRESS
	POPEQ {R1}                @ restore VALUE
	POPEQ {R0}                @ restore INDEX
	ADD R0, R0, #1          @ increment index
	B   _search            		@ branch to next loop iteration

_bool:
	CMP R0, #1				@ if true
	BEQ _exit					@ exit
	LDR R0, =invalid		@ else, 
	BL printf						@ print non existant
	B _exit

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_empty       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

.data

.balign 							4
a:              		.skip       44
printf_str:     	.asciz      "array_a[%d] = %d\n"
format_str:     .asciz      "%d"
prompt:			.asciz		"ENTER A SEARCH VALUE: "
invalid:			.asciz		"That value does not exist in the array!\n"
exit_str:       	.ascii      "Terminating program.\n"
exit_empty:		.ascii		"\n"
