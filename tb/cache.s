# Cache test program

li s0, 0xDEAC
li s1, 12 # for markers
li a0, 0xAA # marker
li t0, 5
li t1, 0x00
li t2, 0x1C
sb t0, 0(t1) # store at 0x00
li t0, 4
sb t0, 4(t1) # store at 0x04
lw t0, 0(t1) # load from 0x00, should be a hit
mv a0, t0
lw t0, 4(t1) # load from 0x04, should be a hit
mv a0, t0
addi a0, s0, 1 # marker DEAD
lw t5, 4(t1) # load from 0x04, should be a hit
lw t6, 0(t1) # load from 0x00, should be a hit
sub a0, a0, s1 # marker DEA1
lw t5, 0(t2) # load from 0x1C, should be a miss
addi a0, a0, 1 # marker DEA2
lw t5, 0(t2) # load from 0x1C, should be a hit
addi a0, a0, 1 # marker DEA3
lw t5, 2(t2) # load from 0x02, unaligned read, should be a miss
addi a0, a0, 1 # marker DEA4
sw t5, 2(t2) # load from 0x02, unaligned write, should invalidate cache
li a0, 0xDEAD

