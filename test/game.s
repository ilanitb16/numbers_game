.section .data                              # contains initialized data
	counter: .long 5                        # amount of loops
    user_number: .int 0                     # rReserve space for the input integer
    computer_number: .int 0

.section .rodata	                        # read only data section
    str: .string "Guess a number between 0 and 9:\n"
    computer_print_format: .string "My number is: %d\n"
    user_print_format: .string "User number is %d\n"
    time_print_format: .string "Time is: %d\n"
    format: .string "%d"                    # format string for scanf, specifying integer input
    seed: .long 0

.text	#the beginnig of the code
.globl	do_main	                            # the label "do_main" is used to state the initial point of this program
.type	do_main, @function	                # the label "do_main" representing the beginning of a function

.extern my_time

do_main:	# the main function:
    pushq %rbp		                        # save the old frame pointer
    movq %rsp, %rbp	                        # create the new frame pointer

    mov $0, %rax                            # clear rax registry
    call  my_time                           # Get the current time
    #movq %rax, seed

    # Print time
    movq $time_print_format, %rdi           # pass format string to the function
    movq %rax, %rsi                         # pass time to the function
    movq $0, %rax                           # clear rax registry
    call printf                             # print time

    movq seed, %rsi                         # pass time to the function
    call srand                              # initialize the random number generator with a seed value.

    mov counter, %ecx                       # loop counter

    start_loop:
        mov %ecx, counter                   # store counter in x variable before call C functions

        # print: Guess a number between 0 and 9
        movq	$str, %rdi# the string is the only paramter passed to the printf function-first parameter goes in %rdi
        movq	$0, %rax
        call	printf		                # calling to printf AFTER we passed its parameters.

        # prepare the arguments and call scanf to get user number
        movq $user_number, %rsi             # pass input addres string to scanf
        movq $format, %rdi                  # pass format string to scanf
        call scanf                          # Call scanf to read an integer from the console

        # print user number
        movq $user_print_format, %rdi       # pass format string to the function
        movq [user_number], %rsi            # pass user number to the function
        movq $0, %rax                       # clear rax registry
        call printf                         # print user number

        # generate a random number
        call rand                           # Call the rand function, the result stored in %rax

        # divide rax by 10 and get reminder in rdx to get a number between 0 and 9
        movq $10, %rbx
        div %rbx

        # print generated random number
        movq $computer_print_format, %rdi   # pass format string to the function
        movq %rdx, %rsi                     # pass reminder to the function
        movq $0, %rax                       # clear rax registry
        call printf                         # print random value

        mov counter, %ecx                   # restore ecx value
        loop   start_loop                   # jump to start if loop counter is not zero


    movq	$0, %rax	                    # return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	%rbp, %rsp	                    # restore the old stack pointer - release all used memory.
    popq	%rbp		                    # restore old frame pointer (the caller function frame)
    ret			                            # return to caller function (OS)
