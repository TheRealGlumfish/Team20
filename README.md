<center>

# Team 20: RISC-V CPU
RISC-V CPU Project for Imperial EIE 2023/24

---

**_Adam El Jaafari, Archisha Garg, Dimitris Alexopoulos, Toby Browne_**

---

</center>

## Table of Contents

* F1 Program**
* Program Counter & Instruction Memory
* Control Unit 
* ALU (Dimitris)
* Data Memory
* Pipelining and Hazard unit 
* Cache
* Individual Statements:
    * [Adam El Jaafari]
    * [Archisha Garg]
    * [Dimitris Alexopoulos]
    * [Toby Browne]

___

## Overview
___


___

## Contribution Table
___

**Key:** o = Main Contributor; v = Co-Author

Task              | Files                                                                                  | Adam  | Archisha  | Dimitris  | Toby |
:-----------------|:---------------------------------------------------------------------------------------|:-----:|:---------:|:---------:|:----:|
F1 Program        | [f1.s](test/f1.s), [f1_tb.cpp](rtl/f1_tb.cpp)                                          |       |           |     o     |      |
Program Counter   | [pc.sv](rtl/pc.sv)                                                                     |   o   |           |           |      |
Instruction Memory| [instrmem.sv](rtl/instrmem.sv)                                                         |   o   |           |           |   v  |
Control Unit      | [cu.sv](rtl/cu.sv)                                                                     |   v   |     o     |     o     |   v  |
ALU               | [alu.sv](rtl/alu.sv)                                                                   |       |           |     o     |      |
Sign Extend       | [se.sv](rtl/se.sv)                                                                     |       |     o     |           |      |
Data Memory       | [datamem.sv](rtl/datamem.sv)                                                           |       |           |           |   o  |
Top Level         | [cpu.sv](rtl/cpu.sv)                                                                   |       |           |     o     |   o  |
Pipeline Registers| [fetchff.sv](rtl/fetchff.sv), [executeff.sv](rtl/executeff.sv), [memoryff.sv](rtl/memoryff.sv), [decodeff.sv](rtl/decodeff.sv)   |   o   |           |           |  o  |
Hazard Unit       | [hazard.sv](rtl/hazard.sv)                                                             |       |     o     |           |   v  |
Cache             | [cache.sv](rtl/cache.sv)                                                               |   o   |           |     v     |      |
___

## Directory Structure
This is the directory structure that will be used for the project.
Directory | Use
:--------:|:------------------------------------------------
`rtl`     | SystemVerilog modules
`doc`     | Documentation and reports

___

## File Structure
___


___

## Additional Comments
___

