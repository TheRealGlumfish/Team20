module pcmod#(
    parameter WIDTH=32
)(
    //interface signals
    input  logic             clk,      // clock 
    input  logic             rst,      // reset
    input  logic             PCsrc,    // Program counter control (from control unit, do we branch or move to the next address, ie pc=pc+imm or pc=pc+4)
    input  logic [WIDTH-1:0]   ImmOp,  //Immediate value to add to current PC val
    output  logic [WIDTH-1:0]   dout  //current instruction
);

logic [WIDTH-1:0] addr;

pc Pc (
    .clk(clk),
    .rst(rst),
    .PCsrc(PCsrc),
    .ImmOp(ImmOp),
    .PC(addr)
);

rom Rom(
    .PC(addr),
    .instr(dout)
);

endmodule
