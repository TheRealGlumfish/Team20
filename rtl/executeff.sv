module executeff (
    input logic clk,
    //CONTROL PATH INPUTS (Execute stage)
    input logic RegWriteE,
    input logic [1:0] ResultSrcE,
    input logic MemWriteE,

    //CONTROL PATH OUTPUTS (Memory stage)
    output logic RegWriteM,
    output logic [1:0] ResultSrcM,
    output logic MemWriteM,

    //DATA PATH INPUTS (Execute stage)
    input logic [31:0] ALUOutE, //Value of out ALU in execute stage
    input logic [31:0] WriteDataE,// Execute stage address where we write into data memory
    input logic [5:0] RDE, //destination reg of execute stage
    input logic [31:0] PCPlus4E,
    

    //DATA PATH OUTPUTS (Memory stage)
    output logic [31:0] ALUOutM, //Value of out ALU in memory stage
    output logic [31:0] WriteDataM,// Memory pipleline stage ,  address where we write into data memory
    output logic [5:0] RDM, //destination reg of memory stage
    output logic [31:0] PCPlus4M //Pc +4 
);

//CONTROL PATH
always_ff@(posedge clk)
begin
    RegWriteM <=RegWriteE;
    ResultSrcM <= ResultSrcE;
    MemWriteM <= MemWriteE;
end

//DATA PATH
always_ff@(posedge clk)
begin
    ALUOutM <= ALUOutE;
    WriteDataM <= WriteDataE;
    RDM <= RDE;
    PCPlus4M <= PCPlus4E;
end


endmodule



