module cpu(
    input logic clk,
    input logic rst,
    input logic [31:0] ioin,
    output logic [31:0] a0
);

// ALU
logic ALUsrcD;
logic ALUsrcE;

logic [31:0] RD1D;
logic [31:0] RD1E;
logic [31:0] RD2D;
logic [31:0] RD2E;

logic [31:0] SrcAE;
logic [31:0] SrcBE;

logic [3:0] ALUctrlD;
logic [3:0] ALUctrlF;

logic [31:0] ALUout;
logic Zero;

// CU
logic [4:0] rs1D;
logic [4:0] rs2D;
logic [4:0] rs1E;
logic [4:0] rs2E;
logic [4:0] rdD;



logic RegWriteD;
logic RegWriteE;

logic [2:0] ImmSrcD;

logic [31:0] ImmExtD;
logic [31:0] ImmExtE;

logic MemWriteD;
logic MemWriteF;


logic JALR;
logic[2:0] DataWidth;

logic [1:0] ResultSrcD;
logic [1:0] ResultSrcF;


logic [31:0] ReadData;
logic [31:0] PadderIn;
logic [31:0] result;

// PCMEM
logic JumpD;
logic JumpE;
logic [31:0] PCF;
logic [31:0] PCD;
logic [31:0] PCPlus4F;
logic [31:0] PCPlus4D;
logic [31:0] PCPlus4E;

// ROM
logic [31:0] instrF;
logic [31:0] instrD;


// FETCH STAGE:
instrmem instrmem(PCF, instrF);
pc Pc(clk, rst, JumpD, JALR, ImmOp, ALUout, PCF);
fetchff fetchff(clk, instrF, PCF, PCPlus4F, instrD, PCD, PCPlus4D);


// DECODE STAGE:
cu Cu(instrD, Zero, JALR, MemWriteD, RegWriteD, JumpD, ALUsrcD, ResultSrcD, ImmSrcD, ALUctrlD, DataWidth);
se Se(instrD, ImmSrcD, ImmExtD);

assign rs1D = instr[19:15];
assign rs2D = instr[24:20];
assign rdD = instr[11:7];

regfile RegFile(clk, rs1D, rs2D, rdD, RegWrite, result, RD1D, RD2D, a0);
decodeff decodeff(clk, RegWriteD, ResultSrcD, MemWriteD, JumpD, ALUCtrlD, ALUSrcD,
                RegWriteE, ResultSrcE, MemWriteE, JumpE, ALUCtrlE, ALUSrcE,
                RD1D, RD2D, PCD, rs1D, rs2D, rdD, ExtImmD, PCPlus4D,
                RD1E, RD2E, PCE, rs1E, rs2E, rdE, ExtImmE, PCPlus4E);


// EXECUTE STAGE:

always_comb
begin
    case(ForwardAE)
        2'b00:
            SrcAE = RD1E;
        2'b01:
            SrcAE = result;
        2'b10:
            SrcAE = ALUResultM;
    
     case(ForwardBE)
        2'b00:
            regOp2 = RD2E;
        2'b01:
            regOp2 = result;
        2'b10:
            regOp2 = ALUResultM;
end

assign SrcBe = ALUsrcE ? ImmExtE : regOp2;


alu ALU(ALUop1, ALUop2, ALUctrl, ALUout, Zero);
datamem datamem(clk, ALUout, regOp2, MemWrite, DataWidth, ioin, ReadData);

always_comb
begin
    case(ResultSrc)
    2'b00: 
        result = ALUout;
    2'b01:
        result = ReadData; 
    2'b10:
        result = PC + 4;
    2'b11:
        result = ImmOp;
endcase
end

endmodule
