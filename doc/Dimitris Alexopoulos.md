# Dimitris Alexopoulos - Personal Statement
---
## Overview
- [**Register File**](#register-file)
- [**ALU**](#alu-arithmetic-and-logic-unit)
- **Control Unit**
- **Memory**
    * Memory Mapped I/O
    * Cache (talk about misallignment preventing io from being cached)
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
https://github.com/TheRealGlumfish/Team20/blob/232045f4fa1b06537831d65f6331cc133ddbecd7/rtl/alu.sv#L1-L45

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