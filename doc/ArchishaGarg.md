<center>

## RISC-V Processor Coursework

---
## Personal Statement of Contributions

**_Archisha Garg_**

---

</center>

## Overview

* Sign extension unit 
* Control Unit
* Jump Instructions
* Hazard Unit
* Pipelining
* Cache
* Additional Comments

<br>

___

## Sign Extension Unit
___

Relevant Commits:
* [Modified ImmSrc to be 2 bits](https://github.com/TheRealGlumfish/Team20/commit/04c45560ec1b748c9e46bd0184fc669c819d6193)
* [Modified ImmExt to be 32 bits](https://github.com/TheRealGlumfish/Team20/commit/f04898fc080121f2c32890299c7bb39f9a258d54)
* [Added zero extension for LUI instruction in se](https://github.com/TheRealGlumfish/Team20/commit/ad2d5d92f6429d9b93cc9589a967de023ec349e9)


I created the sign extension for lab 4 and also for the single cycle CPU. The initial modification was to change ImmSrc into 2 bits compared to 1 bit to include the B-type instruction as shown below from the lecture slides:
<p align="center"> <img src="images/Lab4ImmSrc.png" /> </p><BR> 
<p align="center"> <img src="images/CPUImmSrc.png" /> </p><BR> 

I had to implement the jal instruction and the jump target address (PCnext) had to be PC + the 21 bit signed signed immediate. The least significant bit had to be set to 0 and the rest 20 came from the Instruction (Instr[31:12]), therefore the code for this was: 
```signextend
case(ImmSrc)
//other cases for other instruction types
2'b11:
    ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0}; 
```
Finally, the ImmSrc had to be changed to 3 bits to include the case for the load upper immediate (U-type) instruction. This required the 32 bit immediate with the upper 20 bits from the instruction and the lower bits to be 0's so the code for this was: 
```signextend
case(ImmSrc)
//other cases for other instruction types
3'b100:
    ImmExt = {Instr[31:12], 12'b0};
```
A default case (which should not be reached) was also added since not all cases for the 3 bit ImmSrc were defined. 

<br>

___

## Control Unit
___

Relevant Commits:
* [Created Main decode and combined with ALU decode to create CU](https://github.com/TheRealGlumfish/Team20/commit/04c45560ec1b748c9e46bd0184fc669c819d6193)
* [Updated maindecode for ResultSrc, MemWrite, 2 bits ImmSrc](https://github.com/TheRealGlumfish/Team20/commit/5fcaaa55b3a1da3352f93b04d9c94c8027869014)
* [Set default 11 for ImmSrc](https://github.com/TheRealGlumfish/Team20/commit/57a5446f203c4547b51d5558d3c638d01eaa7254)
* [Included I type instruction logic](https://github.com/TheRealGlumfish/Team20/commit/fff9755c6c7fd85e6a7d6d86cc3c9bf7cf2bd8bf)
* [Included JALR instruction](https://github.com/TheRealGlumfish/Team20/commit/be4bc6ab4e6db04e95cda745d26687f11d6f587f)

Initially, I created the main decode block inside the control unit which was then combined with the ALU decode block using a top control unit module as shown in diagram:
<p align="center"> <img src="images/InitialCU.png" /> </p><BR> 
I set the outputs from the maindecode (ResultSrc, MemWrite, ALUctrl, ALUSrc, ImmSrc, RegWrite, PCSrc) as shown in the tables below for the required instructions:
<p align="center"> <img src="images/Maindecode1.png" /> </p><BR> 
<p align="center"> <img src="images/Maindecode2.png" /> </p><BR> 


___

## Jump Instructions
___

Relevant Commits:
* [Worked on JAL/JALR logic](https://github.com/TheRealGlumfish/Team20/commit/ff427db7571c20ab5e9848e5e8f461f1aaf131f5)
* [Included JALR instruction in CU](https://github.com/TheRealGlumfish/Team20/commit/be4bc6ab4e6db04e95cda745d26687f11d6f587f)


___

## Hazard Unit
___

Relevant Commits:
* [Created Hazard Unit](https://github.com/TheRealGlumfish/Team20/commit/77eddb8398901ad8f2513df58ddf5f421684f788)
* [Updated with correct logic](https://github.com/TheRealGlumfish/Team20/commit/6c512356eb12e11b8c2859233312946366f5d34e)

___

## Pipelining
___

Relevant Commits:
* [Included JALR in pipeline](https://github.com/TheRealGlumfish/Team20/commit/da7089d74617a440ae77f5e14a4fba20add78744)

___

## Cache
___

Relevant Commits:
* [Created two-way cache](https://github.com/TheRealGlumfish/Team20/commit/2e53c2166b46785e03c45ca9fd98ee656b3f0e3a)


___

## Additional Comments
___



