.section .data                              # contains initialized data
	counter: .int 5                         # amount of loops
    user_number: .int 0                     # reserve space for the user number
    computer_number: .int 0
    seed: .int 0
    random_number: .long 0

.section .rodata	                        # read only data section
    str: .string "What is your guess? "
    user_print_format: .string "User number is %d \n"
    time_print_format: .string "Time is: %d\n"
    numbers_are_equal_message: .string "Congratz! You won!\n"
    numbers_are_not_equal_message: .string "Incorrect.\n"
    you_lost_message: .string "Game over, you lost :(. The correct answer was %d"

    format: .string "%d"                    # format string for scanf, specifying integer input
    seed_num: .string "%d"
    enter_seed_str: .string "Enter configuration seed: "

.text	                                    # the beginnig of the code
.globl	do_main	                            # the label "do_main" is used to state the initial point of this program
.type	do_main, @function	                # the label "do_main" representing the beginning of a function

.extern my_time

do_main:	                                # the main function:
    pushq %rbp		                        # save the old frame pointer
    movq %rsp, %rbp	                        # create the new frame pointer

    mov $0, %rax                            # clear rax registry
    #call  my_time                          # cet the current time
    #movq %rax, seed

    # Print seed string
    movq $enter_seed_str, %rdi              # pass format string to the function
    movq %rax, %rsi                         # pass time to the function
    movq $0, %rax                           # clear rax registry
    call printf                             # print time

    movq    $seed, %rsi
    movq    $seed_num, %rdi                 #first paramter passed to the scanf is in %rdi
    movq    $0, %rax                        #clear rax register
    call    scanf                           #call to scanf after passing its parameters.

    movq [seed], %rsi                       # pass seed to the function
    call srand                              # initialize the random number generator with a seed value.

    # generate a random number
    call rand                           # Call the rand function, the result stored in %rax

    # divide %rax by 11 to get a number between 0 and 10. this will put a reminder into rdx
    movq $11, %rbx
    div %rbx

    mov %rdx, random_number

    mov [counter], %ecx                      # loop counter

    start_loop:
        mov %ecx, counter                   # store %ecx in counter variable

        # print: Guess a number between 0 and 9
        movq	$str, %rdi# the string is the only paramter passed to the printf function-first parameter goes in %rdi
        movq	$0, %rax
        call	printf		                # calling to printf AFTER we passed its parameters.

        # prepare the arguments and call scanf to get user number
        movq $user_number, %rsi             # pass input addres string to scanf
        movq $format, %rdi                  # pass format string to scanf
        call scanf                          # Call scanf to read an integer from the console

        # print user number
        #movq $user_print_format, %rdi       # pass format string to the function
        #movq [user_number], %rsi            # pass user number to the function via %rsi
        #movq $0, %rax                       # clear rax registry
        #call printf                         # print user number

        movq [random_number], %rdx
        cmp %rdx, [user_number]             # compare numbers
        je numbers_are_equal                # jump to 'numbers_are_equal' label
        jmp numbers_are_not_equal           # jump to 'numbers_are_not equal' label

    return_from_print_result:               # continue
        mov [counter], %ecx                   # restore ecx value
        loop start_loop                     # jump to start if loop counter is not zero

    movq $you_lost_message, %rdi       # pass format string to the function
    movq [random_number], %rsi            # pass user number to the function via %rsi
    movq $0, %rax                       # clear rax registry
    call printf

exit:
    movq	$0, %rax	                    # return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	%rbp, %rsp	                    # restore the old stack pointer - release all used memory.
    popq	%rbp		                    # restore old frame pointer (the caller function frame)
    ret			                            # return to caller function (OS)

 numbers_are_equal:
    movq $numbers_are_equal_message, %rdi   # pass format string to the function
    movq $0, %rax                           # clear rax registry
    call printf                             # print random value
    jmp exit

 numbers_are_not_equal:
     movq $numbers_are_not_equal_message, %rdi   # pass format string to the function
     # movq %rdx, %rsi
     movq $0, %rax                           # clear rax register
     call printf                             # print random value
     jmp return_from_print_result
