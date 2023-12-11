module cpu(
    input logic clk,
    input logic rst,
    output logic [31:0] a0
);

// ALU
logic ALUsrc;
logic [31:0] ALUop1;
logic [31:0] ALUop2;
logic [31:0] regOp2;
logic [3:0] ALUctrl;
logic [31:0] ALUout;
logic Zero;

// CU
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic RegWrite;
logic [2:0] ImmSrc;
logic [31:0] ImmOp;
logic MemWrite;
logic JALR;
logic[2:0] DataWidth;

logic [1:0] ResultSrc;
logic [31:0] ReadData;
logic [31:0] PadderIn;
logic [31:0] result;

// PCMEM
logic PCsrc;
logic [31:0] PC;

// ROM
logic [31:0] instr;



instrmem instrmem(PC, instr);

pc Pc(clk, rst, PCsrc, JALR, ImmOp, ALUout, PC);

cu Cu(instr, Zero, JALR, MemWrite, RegWrite, PCsrc, ALUsrc, ResultSrc, ImmSrc, ALUctrl, DataWidth);
se Se(instr, ImmSrc, ImmOp);
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];

// assign result = (ResultSrc = 2'b00) ? ALUout : (ResultSrc = 2'b01) ? ReadData : (ResultSrc = 2'b10) ? PC + 1'd4 : ALUout ;

regfile RegFile(clk, rs1, rs2, rd, RegWrite, result, ALUop1, regOp2, a0);
assign ALUop2 = ALUsrc ? ImmOp : regOp2;
alu ALU(ALUop1, ALUop2, ALUctrl, ALUout, Zero);
datamem datamem(clk, ALUout, regOp2, MemWrite, DataWidth, ReadData);

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
