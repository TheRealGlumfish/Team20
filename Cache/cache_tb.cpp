#include "Vcache.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
/*
    input clk,
    input rst,
    input logic [31:0] addr, //[Tag,set,byte_offset]
    input logic [31:0] datain,
    output logic [31:0] cache_out,
    output logic Hit

);
   */
int main(int argc,char **argv, char **env){
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vcache *top = new Vcache;
    //init trace dump

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp=new VerilatedVcdC;
    top->trace (tfp,99);
    tfp->open ("Vcache.vcd");


    top->addr = 0xFFFFFFF4; //SET 001 TAG 1111
    top->datain=0x73737373;
    top->wen = 1;
    for (i=0; i<40; i++){
        std::cout << "i: " << i << std::endl;

        for (clk =0; clk<2; clk++){
            tfp->dump (2*i +clk);
            top->eval ();
            top->clk = !top->clk;

        }
        if (i==10){
            top->addr = 0xEFFFFFE4; //SET 101 TAG EFF....
            top->datain=0xAAAAAAAA;
        }
        else if (i==11){
            top->addr = 0xEFFFFFE0; //SET 101 TAG EFF....
            top->datain=0xAAABBAAA;
        }
        else if (i==18){
            top->addr = 0xEDFFFFE0; //SET 101 TAG EFF....
            top->datain=0xAAABDEEA;
        }
        if(i>18){
            top->wen = 0;
        }

        if(Verilated::gotFinish()) exit(0);

    }

    tfp->close();
    exit(0);

}

