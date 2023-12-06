#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vinstrmem.h" 

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vinstrmem* top = new Vinstrmem;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;

  top->trace (tfp, 99);
  tfp->open ("instrmem.vcd");

  // initialize simulation input 
  top->pc = 3217031168; 

  // start instruction address
  int programcounter = 3217031168;
  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<1000; simcyc++) {

    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->eval ();
    }

    top->pc = programcounter;
    
    programcounter+=4;
  }

  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}
