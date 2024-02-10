// 322453200 Ilanit Berditchevski

.section .data                              # contains initialized data
	counter: .int 5                         # amount of loops
    seed_number: .int 0                     # reserve space for the seed number
    rand_number: .long 0                    # reserve space for the random number

.section .rodata	                        # read only data section
    user_print_format:  .string "User number is %d \n"
    seed_print_format:  .string "Seed is: %d\n"
    rand_print_format:  .string "Rand is: %d\n"
    lost_print_format:  .string "Game over, you lost :(. The correct answer was %d"

    seed_scan_format:   .string "%d"
    user_scan_format:   .string "%d"

    enter_seed_message:             .string "Enter configuration seed: "
    quess_number_message:           .string "What is your guess? "
    numbers_are_equal_message:      .string "Congratz! You won!\n"
    numbers_are_not_equal_message:  .string "Incorrect.\n"

.text	                                    # the beginnig of the code
.globl	main	                            # the label "main" is used to state the initial point of this program
.type	main, @function	                    # the label "main" representing the beginning of a function

main:	                                    # the main function:
    pushq %rbp		                        # save the old frame pointer
    movq %rsp, %rbp	                        # create the new frame pointer

    # print seed prompt
    movq $enter_seed_message, %rdi          # pass format string to the function
    xorq %rax, %rax                         # clear rax registry
    call printf                             # print seed prompt

    # get seed number
    lea     (%rsp), %rsi                    # overrite the option of the switch case
    movq    $seed_scan_format, %rdi         # load format string
    xorq    %rax, %rax                      # clear rax registry
    call    scanf                           # get seed number
    mov     %rsi, seed_number               # store received value in seed_number variable

    # print seed
    movq    $seed_print_format, %rdi
    mov     seed_number, %rsi
    xorq    %rax, %rax
    call    printf

    # init rand generator
    xorq    %rax, %rax                      # clear rax registry
    mov     seed_number, %rdi               # pass seed number to srand function
    call    srand                           # initialize the random number generator with a seed value.

    # generate a random number
    call    rand                            # call the rand function, the result stored in %rax

    # divide %rax by 11 to get a number between 0 and 10. this will put a reminder into rdx
    movq    $11, %rbx
    div     %rbx                            # divide %rax by 11 (stored in %rbx)
    mov     %rdx, rand_number               # store reminder in random_number variable

    # print random number
    movq    $rand_print_format, %rdi
    mov     rand_number, %rsi
    xorq    %rax, %rax
    call    printf

    movl counter, %ecx                    # init loop counter

    start_loop:
        movl    %ecx, counter               # store %ecx in counter variable

        # print: guess a number prompt
        movq    $quess_number_message, %rdi # the only paramter passed to the printf - first parameter goes in %rdi
        xorq    %rax, %rax                  # clear rax registry
        call    printf		                # calling to printf AFTER we passed its parameters.

        # get user number
        movq    $user_scan_format, %rdi     # pass scan format string
        lea     (%rsp), %rsi                # store user number in %rsi
        xorq    %rax, %rax                  # clear rax register
        call    scanf                       # get user number

        # print user number
        movq    $user_print_format, %rdi    # pass format string to the function
        xorq    %rax, %rax                  # clear rax registry
        call    printf                      # print user number

        movl rand_number, %edx              # store random number in %edx
        cmp (%rsp), %edx                    # compare numbers
        je numbers_are_equal                # jump to 'numbers_are_equal' label
        jmp numbers_are_not_equal           # jump to 'numbers_are_not equal' label

    return_from_print_result:               # continue
        movl counter, %ecx                  # restore ecx value
        loop start_loop                     # jump to start if loop counter is not zero

    movq $lost_print_format, %rdi           # pass format string to the function
    movq rand_number, %rsi                  # pass user number to the function via %rsi
    xorq %rax, %rax                         # clear rax registry
    call printf

exit_program:
    xorq	%rax, %rax	                    # return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	%rbp, %rsp	                    # restore the old stack pointer - release all used memory.
    popq	%rbp		                    # restore old frame pointer (the caller function frame)
    ret			                            # return to caller function (OS)

 numbers_are_equal:
    movq $numbers_are_equal_message, %rdi   # pass format string to the function
    movq $0, %rax                           # clear rax registry
    call printf                             # print random value
    jmp exit_program

 numbers_are_not_equal:
     movq $numbers_are_not_equal_message, %rdi   # pass format string to the function
     # movq %rdx, %rsi
     movq $0, %rax                           # clear rax register
     call printf                             # print random value
     jmp return_from_print_result
