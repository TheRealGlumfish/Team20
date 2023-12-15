<center>

## Team 20: RISC-V CPU

---

**_Adam El Jaafari, Archisha Garg, Dimitris Alexopoulos, Toby Browne_**

---

</center>

## Table of Contents

* F1 Program (Dimitris)
* Program Counter & Instruction Memory 
* Control Unit (Archisha, Dimitris)
* ALU (Dimitris)
* Data Memory 
* Pipelining and Hazard unit (Adam, Archisha, Toby)
* Cache (Adam, Dimitris)
* Individual Statements:
    * [Adam El Jaafari](https://github.com/TheRealGlumfish/Team20/blob/report/doc/Adam%20El%20Jaafari.md)
    * [Archisha Garg](https://github.com/TheRealGlumfish/Team20/blob/report/doc/ArchishaGarg.md)
    * [Dimitris Alexopoulos](https://github.com/TheRealGlumfish/Team20/blob/report/doc/Dimitris%20Alexopoulos.md)
    * [Toby Browne]
<br>

___

## Quick Start
___


<br>

___

## Overview
___


___

## Contribution Table
___

**Note:** o = Main Contributor; v = Co-Author

Task              | Files                                                                                  | Adam  | Archisha  | Dimitris  | Toby |
:----------------:|:---------------------------------------------------------------------------------------|:-----:|:---------:|:---------:|:----:|
Single Cycle      | 
Repo Setup        | SystemVerilog modules and testbench source code                                        |       |           |     o     |      |
Entry Script      |                                                                                        |       |           |           |      |
F1 Program        | [f1_tb.cpp](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/f1_tb.cpp)       |       |           |     o     |      |
Program Counter   | [pc.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/pc.sv)               |   o   |           |           |      |
Instruction Memory| [instrmem.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/instrmem.sv)   |   o   |           |           |      |
Control Unit      | [cu.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/cu.sv)               |   v   |     o     |     o     |      |
ALU               | [alu.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/alu.sv)             |       |           |     o     |      |
Sign Extend       | [se.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/se.sv)               |       |     o     |           |      |
Data Memory       | [datamem.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/datamem.sv)     |       |           |           |      |
Top Level         | [cpu.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/cpu.sv)             |       |           |           |   o  |
Debugging         |                                                                                        |   v   |     v     |           |   v  |
Pipeline          | 
Pipeline Registers| [fetchff.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/fetchff.sv)     |   o   |           |           |      |                                           | [decodeff.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/decodeff.sv)   |       |           |           |      |
                  | [executeff.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/executeff.sv) |       |           |           |      |
                  | [memoryff.sv](https://github.com/TheRealGlumfish/Team20/blob/master/rtl/memoryff.sv)   |       |           |           |      |
Hazard Unit       | [hazard.sv](https://github.com/TheRealGlumfish/Team20/blob/pipeline/rtl/hazard.sv)     |       |     o     |           |   v  |
Pipeline Programs |                                                                                        |       |           |           |   o  |
Top Level         | [cpu.sv](https://github.com/TheRealGlumfish/Team20/blob/pipeline/rtl/cpu.sv)           |       |           |           |   o  |
Debugging         |                                                                                        |       |           |           |   o  |
Cache             | 
One-way           |                                                                                        |   v   |           |     o     |      |
Two-way Incomplete|                                                                                        |       |     o     |           |      |

___

## Specifications
___


___

## File Structure
___


___

## Additional Comments
___

