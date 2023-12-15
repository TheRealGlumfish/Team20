#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcpu.h"
#include <chrono>
#include <thread>
#include <iostream>

#define MAX_SIM_CYC 1000

int main(int argc, char **argv, char **env){
    int simcyc;
    int tick;

    Verilated::commandArgs(argc, argv);
    Vcpu* top = new Vcpu;
    
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("cpu.vcd");


    //initialise simulation inputs
    top->rst = 0;
    top->clk = 0;

    int separateFlag = 0;

    long correctOutputs[23] = {7, 2, 1, 4294967289, 1, 1, 1, 1, 1, 1, 1, 7, 6, 1, 7, 6, 4, 268435455, 4294967295, 4, 268435455, 4294967295, 4096};
    int testCount = 0;
    int correctTests = 0;
    // run simulation for MAX_SIM_CYC cycles
    for(simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++){
        for (tick = 0; tick < 2; tick++){
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        if(top->a0 == 0){
            separateFlag = 1;
        }
        else{
            if(separateFlag == 1){
                separateFlag = 0;

                if(correctOutputs[testCount] == top->a0){
                    correctTests+=1;
                }
                testCount+=1;
            }
        }


        if((Verilated::gotFinish()) /*|| (vbdGetkey() == 'q')*/) {
            // vbdClose();
            tfp->close();
            exit(0);
        }

    }

    std::cout<<correctTests<<"/"<<testCount<<" TESTS PASSED!"<<std::endl;
    tfp->close();
    exit(0);
}
