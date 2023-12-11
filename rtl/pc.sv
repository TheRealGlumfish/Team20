module pc(
    //interface signals
    input  logic          clk,      // clock 
    input  logic          rst,      // reset
    input  logic          PCsrc,      // Program counter control (from control unit, do we branch or move to the next address, ie pc=pc+imm or pc=pc+4)
    input  logic          JALR,      // JALR Flag from the cu that tells us if we have a JALR instruction
    input  logic [31:0]   ImmOp,  //Immediate value to add to current PC val
    input  logic [31:0]   aluout,  //We need ot feed in the value that came out the ALU (rs1 + imm)if JALR taken and assign this to our pc (hbfc00000+ aluout)
    output  logic [31:0]  PC  //next pc after next clk cycle (prev clk if no in next clk cycle)
);

// Ensures that in the beginning our PC value is 0 in beginning, preventing undefined behaviour
initial 
    // this value is the start of instruction memory
    PC = 'hbfc00000;

always_ff @(posedge clk)
begin
    if(rst)
        PC <= 'hbfc00000; //mux selecting immop if PC_CTRL=1 or adds current PC by 4 if not
    else
        begin
            if(JALR)
                PC <= aluout;
            else
                begin
                if(PCsrc)
                    PC <= PC + ImmOp;
                else
                    PC <= PC + 4;
                end
        end
        
end
endmodule


