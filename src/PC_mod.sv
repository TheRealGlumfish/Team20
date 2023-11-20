module PC_mod#(
    parameter WIDTH=32
    
)(
        //interface signals
    input  logic             clk,      // clock 
    input  logic             rst,      // reset
    input  logic             PC_CTRL,      // Program counter control (from control unit, do we branch or move to the next address, ie pc=pc+imm or pc=pc+4)
    input  logic [WIDTH-1:0]   ImmOp,  //Immediate value to add to current PC val
    output  logic [WIDTH-1:0]   PC_curr  //next pc after next clk cycle (prev clk if no in next clk cycle)
);

/* Tried to do soemthign like this but it didn't work propebaly have to use
* a always comb sstatement to do this
logic [WIDTH-1:0] branch_PC= PC + ImmOp;
logic [WIDTH-1:0] incr_PC= PC + 3'b100;
logic [WIDTH-1:0] next_PC= PC_CTRL ? branch_PC : incr_PC ;
*/

logic [WIDTH-1:0] next_PC ;

always_ff @(posedge clk) begin
    if(rst)
        PC_curr <= 0;
    else
        next_PC <= PC_CTRL ? PC_curr + ImmOp : PC_curr + 3'b100 ; PC_curr<= next_PC;
    end
endmodule


