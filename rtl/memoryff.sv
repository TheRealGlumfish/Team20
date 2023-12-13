module memoryff (
    input logic clk,
    //CONTROL PATH INPUTS (Memory stage)
    input logic RegWriteM,
    input logic [1:0] ResultSrcM,

    //CONTROL PATH OUTPUTS (Writeback stage)
    output logic RegWriteW,
    output logic [1:0] ResultSrcW,

    //DATA PATH INPUTS (Memory stage)
    input logic [31:0] ALUOutM, //Value of out ALU in Memory stage
    input logic [31:0] ReadDataM,// Memory Stage - The read data memory value
    input logic [4:0] RDM, //destination reg of Memory stage
    input logic [31:0] PCPlus4M,
    

    //DATA PATH OUTPUTS (Writeback stage)
    output logic [31:0] ALUOutW, //Value of out ALU in writeback stage
    output logic [31:0] ReadDataW,// Writeback pipleline stage ,  address where we write into data memory
    output logic [4:0] RDW, //destination reg of Writeback stage
    output logic [31:0] PCPlus4W //Pc +4 
);

//CONTROL PATH
always_ff@(posedge clk)
begin
    RegWriteW <= RegWriteM;
    ResultSrcW <= ResultSrcM;
end

//DATA PATH
always_ff@(posedge clk)
begin
    ALUOutW <= ALUOutM;
    ReadDataW <= ReadDataM;
    RDW <= RDM;
    PCPlus4W <= PCPlus4M;
end


endmodule



