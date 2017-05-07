.global main
.func main
   
main:
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R5, R0              @ move return value R0 to argument register R1
	@BL _printf

    BL  _prompt             @ branch to prompt procedure with return    
	BL  _getchar              @ branch to scanf procedure with return
    MOV R6, R0              @ move return value R0 to argument register R1
	@BL _printf

    BL  _prompt             @ branch to prompt procedure with return
	BL  _scanf              @ branch to scanf procedure with return
	MOV R8, R0              @ move return value R0 to argument register R1
	@BL _printf

	BL _compare

    BL main

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_printf:
    MOV R10, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1,  R5             @ R1 contains printf argument (redundant line)
    MOV R2,  R6
    MOV R3,  R8
	MOV R9, R4
    BL printf               @ call printf
    MOV PC, R10              @ return
    
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
    CMP R6, #'+'            @ compare against the constant char '@'
    BEQ _add            @ branch to equal handler
    CMP R6, #'-'            @ compare against the constant char '@'
    BNE _subtract          @ branch to not equal handler
    CMP R6, #'*'            @ compare against the constant char '@'
	BNE _multiply
    CMP R6, #'M'            @ compare against the constant char '@'
	BNE _max

_add:
	ADD R4, R5, R8
	BL _printf
	BL main

_subtract:
	SUB R4, R5, R8
	BL _printf
	BL main

_multiply:
	MUL R4, R5, R8
	BL _printf
	BL main

_max:
	

.data
format_str:     .asciz      "%d"
read_char:      .ascii      " "
prompt_str:     .asciz      "Type a number and press enter: "
printf_str:     .asciz      "The answer to %d %c %d is %d \n"
exit_str:       .ascii      "Terminating program.\n"
