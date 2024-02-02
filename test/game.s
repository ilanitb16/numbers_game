.section .data  #contains initialized data
	x: .long 5
    input: .int 1      # Reserve space for the input integer

.section .rodata	#read only data section
    str: .string "Guess a number between 0 and 9:\n"
    code_print: .string "My number is: %d\n"
    user_print: .string "User number is %d\n"
    time: .string "Time is: %d\n"
    format: .string "%d"  # Format string for scanf, specifying integer input
    seed: .long 0

.text	#the beginnig of the code
.globl	do_main	#the label "do_main" is used to state the initial point of this program
.type	do_main, @function	# the label "do_main" representing the beginning of a function

.extern my_time
.extern my_scan

do_main:	# the main function:
    pushq %rbp		    # save the old frame pointer
    movq %rsp, %rbp	    # create the new frame pointer

    mov $0, %rax           # clear rax registry
    call  my_time             # Get the current time
    #movq %rax, seed

    # Print time
    movq $time, %rdi        # pass format string to the function
    movq %rax, %rsi         # pass time to the function
    movq $0, %rax           # clear rax registry
    call printf             # print time

    movq seed, %rsi         # pass time to the function
    call srand  # initialize the random number generator with a seed value.

    mov x, %ecx         # loop counter

    start_loop:
        mov %ecx, x     # store counter in x variable before call C functions

        # print: Guess a number between 0 and 9
        movq	$str, %rdi	#t he string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
        movq	$0, %rax
        call	printf		# calling to printf AFTER we passed its parameters.

        # prepare the arguments and call scanf to get user number
        movq $input, %rsi    # pass input addres string to scanf
        movq $format, %rdi   # pass format string to scanf
        call scanf           # Call scanf to read an integer from the console

        # Print user number
        movq $user_print, %rdi      # pass format string to the function
        movq [input], %rsi          # pass user number to the function
        movq $0, %rax               # clear rax registry
        call printf                 # print user number

        # Generate a random number
        call rand               # Call the rand function, the result stored in %rax

        # we need a number between 0 and 9. divide rax by 10 and get reminder in rdx
        movq $10, %rbx
        div %rbx

        # Print generated random number
        movq $code_print, %rdi  # pass format string to the function
        movq %rdx, %rsi         # pass reminder to the function
        movq $0, %rax           # clear rax registry
        call printf             # print random value

        mov x, %ecx             # restore ecx value
        loop   start_loop       # jump to start if loop counter is not zero


    movq	$0, %rax	#return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
    popq	%rbp		#restore old frame pointer (the caller function frame)
    ret			#return to caller function (OS)
