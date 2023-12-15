# Dimitris Alexopoulos (@TheRealGlumfish) - Personal Statement
---
## Overview
- [**Register File**](#register-file)
- [**ALU**](#alu-arithmetic-and-logic-unit)
- [**Control Unit**](#control-unit)
- [**Memory**](#memory)
    * Memory Mapped I/O
    * Cache
- **F1 Lights Pogram**
    * Jump
    * Subroutine
---
## Register File
https://github.com/TheRealGlumfish/Team20/blob/232045f4fa1b06537831d65f6331cc133ddbecd7/rtl/regfile.sv#L1-L34

The register file was the first module I created [(e04b48d)](https://github.com/TheRealGlumfish/Team20/commit/e04b48d8b42ebd4ae2d57acf921177a2d92ce467), starting at Lab4.
But I was responsible for and continued maintaining it throughout the project.
It was fairly easy and I did not encounter many challenges.

The only intresting part was how to handle the `zero/x0` register.
Having the `zero` register be a normal register poses issues, because (at least in reality) a register cannot be written to twice in the same cycle.
This would pose an issue as if the register is written to, it would need to be instantly set to zero again.
In the end the solution I settled on was having the regfile contain 30 registers instead of 31.
When the register select lines `AD1` and/or `AD2` were selecting the `zero` register zero would be outputed.
Writes while `zero` was selected also did nothing (which is the correct behaviour as per the ISA).
When any other register was selected, the register was accessed from the `registers` "array".
The index had to be offset by -1 as there was one less actual register in the `registers` "array".
This led to the correct behaviour [(8612d56)](https://github.com/TheRealGlumfish/Team20/commit/8612d564800849b0fa6ffcedcfd5cdd0a8e47c71), [(0da1dd3)](https://github.com/TheRealGlumfish/Team20/commit/0da1dd3d7a3ab50a90e3b0d43608fc16a95915e7).

---

## ALU (Arithmetic and Logic Unit)
https://github.com/TheRealGlumfish/Team20/blob/729bc1d2dc56a0c9f65dc3fbdfd498d9bafcaccf/rtl/alu.sv#L1-L48

The ALU was the second module I created [(2b6210b)](https://github.com/TheRealGlumfish/Team20/commit/2b6210b704cae09d5a97687c8588cc7079b9337d) (again during Lab4) and then maintained and developed throughout the project.
Initially the ALU only supported addition and the equality flag.

It was then expanded with more operations and a control signal `ALUctrl` to switch between them [(0da1dd3)](https://github.com/TheRealGlumfish/Team20/commit/0da1dd3d7a3ab50a90e3b0d43608fc16a95915e7).
Since the ALU has less operations than potential values in the `ALUctrl` signal, the default case is for it to output `0xDEAD` if the signal doesn't have a valid value.
This was the first instance of using magic numbers for debugging invalid control signals and was useful throughout other parts of the project.

The ALU did not always support all the operations of the ISA as `ALUctrl` was originally 3-bits due to the use of a ALU deocoder module and the values for `ALUctrl` were choose arbitrarily.
Once the control unit was reworked and the decoder was removed, `ALUctrl` was made into a 4-bit signal, which meant all the ISA arithemtic and logical operations could be supported [(aef8ccf)](https://github.com/TheRealGlumfish/Team20/commit/aef8ccf1e72682f6c509b147ce504f559e7afbb4).
This also gave rise to the `ALUctrl` values being the `funct3` of the relevant instructions which meant no custom value-operations pairings had to be created and the values the ISA has standardized can be used.
The MSB of `ALUctrl` was used to distinguish between operations where `funct3` is the same, such as `add` and `sub`, `srl` and `sra`.

One of the challenges I had when implementing the ALU was how to handle the signed/unsigned set less than.
With the help of my teammate @tobybrowne we were able to figure it out [(49f2e6d)](https://github.com/TheRealGlumfish/Team20/commit/49f2e6d1b9253a89c54992b0742cf6cb97b484b8), with a final fix by @tobybrowne [(382bc15)](https://github.com/TheRealGlumfish/Team20/commit/31c86d2607695f7e8).
Testing the ALU was fairly simple as the operations do not involve any state.

---

## Control Unit
https://github.com/TheRealGlumfish/Team20/blob/729bc1d2dc56a0c9f65dc3fbdfd498d9bafcaccf/rtl/cu.sv#L1-L181

The control unit was a module that my teammates @AElja and @Archisag23 originally worked on.
My involvement began when I wanted to implement the full range of ALU operations, which at the time were not supported as the `ALUctrl` signal had not been set.
While settin the `ALUctrl` signal to support the added instructions I realized I did not have enough bits in the signal to represent all the ALU operations.

This is when I tried to extend the control unit and quickly realized it wasn't very extensible and used a lot of hardcode logic.
This is where me and my teammate (who wanted to get all the jump instructions working) @tobybrowne started to look at how we can rework the control unit.
He made a spreadsheet with all the values for the various control signals like `MemWrite`, `RegWrite`, etc.
I looked at how we can spot patters in the instruction set, particularly in regards to I-Type and R-Type instructions which use the ALU.
Unsprinsingly (especially how RISCV is based on the principle that "Simplicity favours regularity") I managed to spot a few patterns using the following table.

![R-Type Instructions](images/rtype.png)

Firstly all R-Type instructions have the same opcode, the same pattern follows for all distinc categories for instructions.
This is the first way we differentiate what we do in the CU.
Secondly all the different ALU operations are distinguished by the value of `funct3`.
Thus `funct3` was directly used as ALUctrl.
The only problem is that `add` and `sub`, `srl` and `sra` have the same `funct3`.
They are differentiated by bit-5 of `funct7`.
Thus `funct7[5]` and `funct3` were combined to form a 4-bit ALU control signal.

![I-Type Instructions](images/itype.png)

I-Type instructions followed the exact pattern therefore, the same logic was used.
This allowed us to implement a much simpler and more readable control unit that was a lot easier to debug as all the instruction types were handled seperately in each case, and the common patterns from each instruction type were extracted and used to simplify the control unit logic.

Having made these discoveries and with the help of my teammate and the spreadsheet he had created, I rewrote the control unit from scratch with no seperate decoder modules [(aef8ccf)](https://github.com/TheRealGlumfish/Team20/commit/aef8ccf1e72682f6c509b147ce504f559e7afbb4), [(084e9ee)](https://github.com/TheRealGlumfish/Team20/commit/084e9ee2e0677fadec1be0822816c87f8f22cf03), [(7c10a38)](https://github.com/TheRealGlumfish/Team20/commit/7c10a3821896fbd2b07d18a90ea0b97623f39aa7), [(73e5bba)](https://github.com/TheRealGlumfish/Team20/commit/73e5bba2b392c0068fd0eac87bcaad4cd75215a9).
The result was us being able to support all instructions with the exception of `auipc` but also a control unit that was much more maintainable and easier to pipeline and add cache support.

---

## Memory

### Memory Mapped I/O

https://github.com/TheRealGlumfish/Team20/blob/729bc1d2dc56a0c9f65dc3fbdfd498d9bafcaccf/rtl/datamem.sv#L1-L99

```SystemVerilog
if(addr > 32'hBFC00FFF)
begin
    if(addr == 32'hFFFFFFFF) 
        dout = ioin1;
    else // should be used with 0xFFFFFFDF
        dout = ioin2;
end
```

For the F1 lights program, a trigger signal was required which could be implemented a number of ways.
I choose to do memory mapped I/O (in this case only input).
I did this by creating two lines in the data memory and top-level cpu module `ioin1` and `ioin2` which were both a word wide [(62a04e7)](https://github.com/TheRealGlumfish/Team20/commit/62a04e7b49e2e2a31f45c4efc067c665d0601129), [(afeb425)](https://github.com/TheRealGlumfish/Team20/commit/afeb4255f20ebcb8ae266e1f47ac3f38717bae18).
These were mapped to the addresses `0xFFFFFFFF` and `0xFFFFFFDF` respectively as its unused space in the memory map.
The memory addresses are not word aligned which disables (forces a miss) in the cache as this would cause cache/memory inconsistencies.
Thus all the programmer has to do to access the value of these signals from assembly code is simply load from these memory addresses.
This makes for a simple and easy to use interface for the programmer.
The logic for this is seen in the code block above.
All that had to be done is connect the memory output to the signal `ioin1` or `ioin2` depending on the addressed accessed.
More input signals could be easily added by making the `if` statement a case with different addresses, thus making this approach for I/O very expandable without much additional hardware/code (HDL).

### Cache

https://github.com/TheRealGlumfish/Team20/blob/ed2cd26788e19efcbd5ba0510957f485e3e289e3/rtl/cache.sv#L1-L105

My second contribution to memory was refactoring the cache that my teammate @AElja made.
When I was testing the cache I was encountering some problems so I decided to refactor the module from the ground up to fix the issue and also make it more readable, as well as gain a better understanding on how it worked.
My design ended up being very similar to his, with the exception of the new caching policy that I implemented [(83d48ce)](https://github.com/TheRealGlumfish/Team20/commit/83d48ce1e3fa1ad458490adb6e02dc47c422c775).
During writting the cache I realized that memory addresses that were offset by between `0b11` and `0b01` would be treated as the same by the cache as they would have the same tag and set number, as the last two bits of the address are discarded (the so called byte offset).
This could cause the cache to give out incorrect data if the cpu requests address `0b000` and `0b001` the cache would give the same cache line for both even though they could contain different data (the last and first byte of the word).
Thus I added a policy of considering any unaligned (non-word aligned) access a cache hit.
If the cpu attemped to write to memory in an unaligned fashion and the cache contains that word, (same tag and set), the cache line would be invalidated.
Additionally if two adjacent cachelines (consecutive cache sets) contain contain consecutive memory words, both cache lines are invalidated to prevent data in memory having changed and cache being out of sync.
The logic that controls this is the following.
```SystemVerilog
    logic aligned;
    logic hit;

    assign aligned = addr[1:0] == 2'b00; 
    assign hit = (aligned && ctag == itag && cvalid);

    always_ff@(posedge clk)
    if(wen && cache_en && !aligned) // if unaligned write, invalidate current set
    begin        
        if(cache_tag[iset] == itag) // if the cache holds part of the word, the word must be invalidated
        begin
            cache_valid[iset] <= 0;
            if(cache_tag[iset] == cache_tag[iset + 1]) // if two adjacent sets share the same tag, it means they are adjacent words and must be both invalidated
                cache_valid[iset + 1] <= 0;
        end
    end
```
This policy of not using cache for unaligned access means that memory mapped I/O is not cached which is what we want to happen, as the inputs `ioin1` and `ioin2` change independently of writes and thus would be out of sync.