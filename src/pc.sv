module pc(
    //interface signals
    input  logic          clk,      // clock 
    input  logic          rst,      // reset
    input  logic          PCsrc,      // Program counter control (from control unit, do we branch or move to the next address, ie pc=pc+imm or pc=pc+4)
    input  logic [31:0]   ImmOp,  //Immediate value to add to current PC val
    output  logic [31:0]  PC  //next pc after next clk cycle (prev clk if no in next clk cycle)
);

// Insures that in the beginning our PC value is 0 in beginning, preventing undefined behaviour

initial 
    PC = 0;

always_ff @(posedge clk) 
    if(rst)
        PC <= 0; //mux selecting immop if PC_CTRL=1 or adds current PC by 4 if not
    else 
        PC <= PCsrc ? PC + ImmOp : PC + 4 ;

endmodule


