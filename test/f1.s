.text

main:
    li a0, 0 # initialize lights to off
    jal lfsr

light0:
    lw t5, 0(t6) 
    beqz t5, light0
    addi a0, a0, 0b00000001

light1:
    lw t5, 0(t6) 
    beqz t5, light1
    addi a0, a0, 0b00000010

light2:
    lw t5, 0(t6) 
    beqz t5, light2
    addi a0, a0, 0b00000100

light3:
    lw t5, 0(t6) 
    beqz t5, light3
    addi a0, a0, 0b00001000

light4:
    lw t5, 0(t6) 
    beqz t5, light4
    addi a0, a0, 0b00010000

light5:
    lw t5, 0(t6) 
    beqz t5, light5
    addi a0, a0, 0b00100000

light6:
    lw t5, 0(t6) 
    beqz t5, light6
    addi a0, a0, 0b01000000

light7:
    lw t5, 0(t6) 
    beqz t5, light7
    addi a0, a0, 0b10000000

count:
    jal counter # start counting until lights go off
    li a0, 0
    jal release # wait for ioin to be released back to 0
    j main # loop b back to start

# generates a pseudorandom sequence, returning when ioin (0xFFFFFFFF) is set to 1
# return value is saved to a1
lfsr:
    li t0, 1
    li t6, 0
    not t6, t6
_lfsr_loop:
    mv t1, t0 # shift register
    andi t2, t1, 0b0100
    andi t3, t1, 0b01000000
    srli t2, t2, 2
    srli t3, t3, 6
    xor t4, t2, t3
    slli t0, t0, 1
    add t0, t0, t4
    andi t0, t0, 0b11111111
    lw t5, 0(t6)
    beqz t5, _lfsr_loop # loop until ioin is 1
    mv a1, t0 # save return value
    ret

# counts until the value in a1 and returns
counter:
    li t0, 0 
_counter_loop:
    add t0, t0, 1
    bltu t0, a1, _counter_loop
    ret
    
# loops until ioin goes to zero
release:
    li t6, 0
    not t6, t6
_release_loop:
    lw t5, 0(t6)
    bgtz t5, _release_loop
    ret
