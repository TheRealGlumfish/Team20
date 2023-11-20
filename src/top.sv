module top#(
    parameter WIDTH=32
)(
        //interface signals
    input  logic             clk,      // clock 
    input  logic             rst,      // reset
    input  logic             PC_CTRL,      // Program counter control (from control unit, do we branch or move to the next address, ie pc=pc+imm or pc=pc+4)
    input  logic [WIDTH-1:0]   ImmOp,  //Immediate value to add to current PC val
    output  logic [WIDTH-1:0]   dout  //current instruction
);

logic [WIDTH-1:0] addr;

PC_mod PC (
    .clk(clk),
    .rst(rst),
    .PC_CTRL(PC_CTRL),
    .ImmOp(ImmOp),
    .PC_curr(addr)
);

rom Rom(
    .PC(addr),
    .instr(dout)
);

endmodule
