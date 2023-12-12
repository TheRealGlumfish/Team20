module decodeff (
    input logic clk,
    input logic clear,
    //CONTROL PATH INPUTS (Decode stage)
    input logic RegWriteD,
    input logic [1:0] ResultSrcD,
    input logic MemWriteD,
    input logic JumpD,
    //input logic BranchD,
    input logic [2:0] ALUControlD,
    input logic ALUSrcD,

    //CONTROL PATH OUTPUTS (Execute stage)
    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic JumpE,
    //output logic BranchE,
    output logic [2:0] ALUControlE,
    output logic ALUSrcE,

    //DATA PATH INPUTS (Decode stage)
    input logic [31:0] RD1D, //Data out of Reg port 1 in decode stage
    input logic [31:0] RD2D,// Data out of Reg port 2 in decode stage
    input logic [31:0] PCD, //PC of the decode stage 
    input logic [5:0] RS1D, //source reg 1 of decode stage
    input logic [5:0] RS2D,//source reg 2 of decode stage
    input logic [5:0] RDD, //destination reg of decode stage
    input logic [31:0] ExtImmD,
    input logic [31:0] PCPlus4D,
    
    //DATA PATH OUTPUTS (Execute stage)
    output logic [31:0] RD1E, //Data out of reg port 1 in execute stage
    output logic [31:0] RD2E, //Data out of reg port 2 in execute stage
    output logic [31:0] PCE, //PC of execute stage
    output logic [5:0] RS1E, //Data out of reg port 1 in execute stage
    output logic [5:0] RS2E, //Data out of reg port 1 in execute stage
    output logic [5:0] RDE, //destination reg of decode stage
    output logic [31:0] ExtImmE,//Sign extended imm of the execute stage
    output logic [31:0] PCPlus4E //Pc +4 
);

always_ff@(posedge clk)
begin
    if(clear)
        begin
            // CONTROL PATH
            RegWriteE <= 0;
            ResultSrcE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            ALUControlE <= 0;
            ALUSrcE <= 0;

            // DATA PATH
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            RS1E <= 0;
            RS1E <= 0;
            RDE <= 0;
            ExtImmE <= 0;
            PCPlus4E <= 0;
        end
    else
        begin
            // CONTROL PATH
            RegWriteE <=RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;

            // DATA PATH
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            RS1E <= RS1D;
            RS1E <= RS1D;
            RDE <= RDD;
            ExtImmE <= ExtImmD;
            PCPlus4E <= PCPlus4D;
        end
    
end



endmodule


