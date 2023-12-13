module cpu(
    input logic clk,
    input logic rst,
    input logic [31:0] ioin,
    output logic [31:0] a0
);

logic JALR;



logic[2:0] DataWidthM;
logic[2:0] DataWidthE;
logic[2:0] DataWidthD;

// FETCH STAGE: 
logic [31:0] PCF;
logic [31:0] PCPlus4F;
logic [31:0] instrF;
logic PCSrc;

// TODO checkout pc aluout
instrmem instrmem(PCF, instrF);
pc Pc(clk, rst, PCSrc, JALR, PCtarget, ALUout, StallF, PCF, PCPlus4F);
fetchff fetchff(clk, instrF, PCF, PCPlus4F, StallD, FlushD, instrD, PCD, PCPlus4D);

// DECODE STAGE:
logic [31:0] instrD;
logic [31:0] PCPlus4D;
logic [31:0] PCD;
logic [4:0] rs1D;
logic [4:0] rs2D;
logic [4:0] rdD;
logic [31:0] ImmExtD;
logic [31:0] RD1D;
logic [31:0] RD2D;

logic RegWriteD;
logic [1:0] ResultSrcD;
logic MemWriteD;
logic BranchD;
logic [3:0] ALUCtrlD;
logic ALUSrcD;
logic [2:0] ImmSrcD;


cu Cu(instrD, JALR, MemWriteD, RegWriteD, BranchD, ALUSrcD, ResultSrcD, ImmSrcD, ALUCtrlD, DataWidthD);
se Se(instrD, ImmSrcD, ImmExtD);

assign rs1D = instrD[19:15];
assign rs2D = instrD[24:20];
assign rdD = instrD[11:7];

regfile RegFile(clk, rs1D, rs2D, rdD, RegWriteW, resultW, RD1D, RD2D, a0);

decodeff decodeff(clk, FlushE, RegWriteD, ResultSrcD, MemWriteD, BranchD, DataWidthD, ALUCtrlD, ALUSrcD,
                RegWriteE, ResultSrcE, MemWriteE, BranchE, DataWidthE, ALUCtrlE, ALUSrcE,
                RD1D, RD2D, PCD, rs1D, rs2D, rdD, ImmExtD, PCPlus4D,
                RD1E, RD2E, PCE, rs1E, rs2E, rdE, ImmExtE, PCPlus4E);

// EXECUTE STAGE:
logic RegWriteE;
logic [1:0] ResultSrcE;
logic MemWriteE;
logic BranchE;
logic [3:0] ALUCtrlE;
logic ALUSrcE;

logic [31:0] RD1E;
logic [31:0] RD2E;
logic [31:0] PCE;
logic [4:0] rs1E;
logic [4:0] rs2E;
logic [4:0] rdE;
logic [31:0] ImmExtE;

logic [31:0] SrcAE;
logic [31:0] SrcBE;

logic [31:0] ALUResultE;
logic [31:0] regOp2;
logic [31:0] PCPlus4E;
logic [31:0] PCtarget;

logic[31:0] ALUout;

logic ZeroE;

assign PCtarget = PCE + ImmExtE;

always_comb
begin
    case(ForwardAE)
        2'b00:
            SrcAE = RD1E;
        2'b01:
            SrcAE = resultW;
        2'b10:
            SrcAE = ALUResultM;
    endcase
    
    case(ForwardBE)
        2'b00:
            regOp2 = RD2E;
        2'b01:
            regOp2 = resultW;
        2'b10:
            regOp2 = ALUResultM;
    endcase
end

assign SrcBE = ALUSrcE ? ImmExtE : regOp2;

alu ALU(SrcAE, SrcBE, ALUCtrlE, ALUResultE, ZeroE);


//BRANCH LOGIC:
always_comb
begin
    if(BranchE == 0)
        PCSrc = 0;
    else
        case(ALUCtrlE)
            4'b1001: // beq
            begin
                PCSrc = ZeroE;
            end
            4'b1001: // bne
            begin
                PCSrc = !ZeroE;
            end
            4'b0011: // blt
            begin
                PCSrc = !ZeroE;
            end
            4'b0010: // bge
            begin
                PCSrc = ZeroE;
            end
            4'b0011: // bltu
            begin
                PCSrc = !ZeroE;
            end
            4'b0011: // bgeu
            begin
                PCSrc = ZeroE;
            end
        endcase
end

executeff executeff(clk, RegWriteE, ResultSrcE, MemWriteE, DataWidthE,
                        RegWriteM, ResultSrcM, MemWriteM, DataWidthM,
                        ALUResultE, regOp2, rdE, PCPlus4E,
                        ALUResultM, WriteDataM, rdM, PCPlus4M);

// MEMORY STAGE:  
logic RegWriteM;
logic [1:0] ResultSrcM;
logic MemWriteM;

logic [31:0] ALUResultM;
logic [31:0] WriteDataM;
logic [4:0] rdM;
logic [31:0] PCPlus4M;

logic [31:0] ReadDataM;

datamem datamem(clk, ALUResultM, WriteDataM, MemWriteM, DataWidthM, ioin, ReadDataM);

memoryff memoryff(clk, RegWriteM, ResultSrcM,
                        RegWriteW, ResultSrcW,
                        ALUResultM, ReadDataM, rdM, PCPlus4M,
                        ALUResultW, ReadDataW, rdW, PCPlus4W);

// OUTER STAGE:
logic [1:0] ResultSrcW;
logic [31:0] ALUResultW;
logic [31:0] ReadDataW;
logic [31:0] PCPlus4W;
logic [4:0] rdW;
logic RegWriteW;
logic [31:0] resultW;

always_comb
begin
    case(ResultSrcW)
    2'b00: 
        resultW = ALUResultW;
    2'b01:
        resultW = ReadDataW; 
    2'b10:
        resultW = PCPlus4W;
    endcase
end

// HAZARD UNIT:
logic [1:0] ForwardAE;
logic [1:0] ForwardBE;

logic StallF;
logic StallD;
logic FlushD;
logic FlushE;

logic MemtoRegE;

assign MemtoRegE = ResultSrcE[0];

hazard hazard(rs1E, rs2E, rs1D, rs2D, rdM, rdW, rdE, 
            MemtoRegE, RegWriteM, RegWriteW, PCSrc,
            StallF, StallD, FlushE, FlushD, ForwardAE,
            ForwardBE);

endmodule
