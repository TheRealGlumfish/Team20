#include "Vcu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
/*
   input  logic             clk,      // clock 
   input  logic             rst,      // reset
   input  logic             PC_CTRL,      // Program counter control (from control unit, do we branch or move to the next address, ie pc=pc+imm or pc=pc+4)
   input  logic [WIDTH-1:0]   ImmOp,  //Immediate value to add to current PC val
   output  logic [WIDTH-1:0]   PC,  //next pc after next clk cycle (prev clk if no in next clk cycle)
   */
int main(int argc,char **argv, char **env){
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vcu *top = new Vcu;
    //init trace dump

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp=new VerilatedVcdC;
    top->trace (tfp,99);
    tfp->open ("Vtop.vcd");


    top->instr= 0b1100011;
    top->Zero=1;

    for (i=0; i<40; i++){

        for (clk =0; clk<2; clk++){
            tfp->dump (2*i +clk);
            top->eval ();

        }


        if(Verilated::gotFinish()) exit(0);

    }

    tfp->close();
    exit(0);

}

