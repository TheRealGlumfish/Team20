module cpu(
    input logic clk,
    input logic rst,
    input logic [31:0] ioin,
    output logic [31:0] a0
);

// ALU
logic ALUSrcD;
logic ALUSrcE;

logic [31:0] RD1D;
logic [31:0] RD1E;
logic [31:0] RD2D;
logic [31:0] RD2E;

logic [31:0] SrcAE;
logic [31:0] SrcBE;

logic [3:0] ALUCtrlD;
logic [3:0] ALUCtrlF;
logic [3:0] ALUCtrlE;

logic [31:0] ALUResultE;
logic [31:0] ALUResultM;
logic [31:0] ALUResultW;
logic Zero;

// CU
logic [4:0] rs1D;
logic [4:0] rs2D;
logic [4:0] rs1E;
logic [4:0] rs2E;
logic [4:0] rdD;
logic [4:0] rdE;
logic [4:0] rdM;
logic [4:0] rdW;



logic RegWriteD;
logic RegWriteE;
logic RegWriteM;
logic RegWriteW;

logic [2:0] ImmSrcD;

logic [31:0] ImmExtD;
logic [31:0] ImmExtE;

logic MemWriteD;
logic MemWriteE;
logic MemWriteM;


logic JALR;
logic[2:0] DataWidth;

logic [1:0] ResultSrcD;
logic [1:0] ResultSrcF;
logic [1:0] ResultSrcM;
logic [1:0] ResultSrcW;
logic [1:0] ResultSrcE;


logic [31:0] ReadDataM;
logic [31:0] ReadDataW;
logic [31:0] PadderIn;
logic [31:0] result;

// PCMEM
logic JumpD;
logic JumpE;
logic [31:0] PCF;
logic [31:0] PCD;
logic [31:0] PCE;
logic [31:0] PCPlus4F;
logic [31:0] PCPlus4D;
logic [31:0] PCPlus4E;
logic [31:0] PCPlus4M;
logic [31:0] PCPlus4W;



//HAZARD
logic [1:0] ForwardAE;
logic [1:0] ForwardBE;


// ROM
logic [31:0] instrF;
logic [31:0] instrD;


logic [31:0] regOp2;
logic [31:0] WriteDataM;


// FETCH STAGE:
instrmem instrmem(PCF, instrF);
pc Pc(clk, rst, JumpD, JALR, ImmOp, ALUout, PCF); // TODO sort out ALUout
fetchff fetchff(clk, instrF, PCF, PCPlus4F, instrD, PCD, PCPlus4D);


// DECODE STAGE:
cu Cu(instrD, Zero, JALR, MemWriteD, RegWriteD, JumpD, ALUSrcD, ResultSrcD, ImmSrcD, ALUCtrlD, DataWidth);
se Se(instrD, ImmSrcD, ImmExtD);

assign rs1D = instrD[19:15];
assign rs2D = instrD[24:20];
assign rdD = instrD[11:7];

regfile RegFile(clk, rs1D, rs2D, rdD, RegWriteW, result, RD1D, RD2D, a0);
decodeff decodeff(clk, RegWriteD, ResultSrcD, MemWriteD, JumpD, ALUCtrlD, ALUSrcD,
                RegWriteE, ResultSrcE, MemWriteE, JumpE, ALUCtrlE, ALUSrcE,
                RD1D, RD2D, PCD, rs1D, rs2D, rdD, ImmExtD, PCPlus4D,
                RD1E, RD2E, PCE, rs1E, rs2E, rdE, ImmExtE, PCPlus4E);


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
    endcase
    
    case(ForwardBE)
        2'b00:
            regOp2 = RD2E;
        2'b01:
            regOp2 = result;
        2'b10:
            regOp2 = ALUResultM;
    endcase
end

assign SrcBE = ALUSrcE ? ImmExtE : regOp2;

alu ALU(SrcAE, SrcBE, ALUCtrlE, ALUResultE, Zero);

executeff executeff(clk, RegWriteE, ResultSrcE, MemWriteE,
                        RegWriteM, ResultSrcM, MemWriteM, 
                        ALUResultE, regOp2, rdE, PCPlus4E,
                        ALUResultM, WriteDataM, rdM, PCPlus4M);

// MEMORY STAGE:  
datamem datamem(clk, ALUResultM, WriteDataM, MemWriteM, DataWidth, ioin, ReadDataM);

memoryff memoryff(clk, RegWriteM, ResultSrcM,
                        RegWriteW, ResultSrcW,
                        ALUResultM, ReadDataM, rdM, PCPlus4M,
                        ALUResultW, ReadDataW, rdW, PCPlus4W);

// OUTER STAGE:
always_comb
begin
    case(ResultSrcW)
    2'b00: 
        result = ALUResultW;
    2'b01:
        result = ReadDataW; 
    2'b10:
        result = PCPlus4W;
    2'b11: // TODO sort this out
        result = ImmOp;
    endcase
end

endmodule
