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
logic [2:0] ALUctrl;
logic [31:0] ALUout;
logic EQ;

// CU
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic RegWrite;
logic [1:0] ImmSrc;
logic [31:0] ImmOp;
logic MemWrite;
logic ResultSrc;

// PCMEM
logic PCsrc;
logic [31:0] PC;

// ROM
logic [31:0] instr;

pc Pc(clk, rst, PCsrc, ImmOp, PC);
rom Rom(PC, instr);
cu Cu(instr, EQ, PCsrc, ResultSrc, MemWrite, ALUsrc, RegWrite, ImmSrc, ALUctrl);
se Se(instr, ImmSrc, ImmOp);
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];
regfile RegFile(clk, rs1, rs2, rd, RegWrite, ALUout, ALUop1, regOp2, a0);
assign ALUop2 = ALUsrc ? ImmOp : regOp2;
alu ALU(ALUop1, ALUop2, ALUctrl, ALUout, EQ);

endmodule
