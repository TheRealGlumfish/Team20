module cpudebug(
    input logic clk,
    input logic rst,
    output logic ALUsrc,
    output logic [31:0] ALUop1,
    output logic [31:0] ALUop2,
    output logic [31:0] regOp2,
    output logic [2:0] ALUctrl,
    output logic [31:0] ALUout,
    output logic EQ,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic RegWrite,
    output logic ImmSrc,
    output logic [31:0] ImmOp,
    output logic PCsrc,
    output logic [31:0] PC,
    output logic [31:0] instr,
    output logic [31:0] a0
);

pc Pc(clk, rst, PCsrc, ImmOp, PC);
rom Rom(PC, instr);
cu Cu(instr, EQ, PCsrc, ALUsrc, RegWrite, ImmSrc, ALUctrl);
se Se(instr, ImmSrc, ImmOp);
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];
regfile RegFile(clk, rs1, rs2, rd, RegWrite, ALUout, ALUop1, regOp2, a0);
assign ALUop2 = ALUsrc ? ImmOp : regOp2;
alu ALU(ALUop1, ALUop2, ALUctrl, ALUout, EQ);

endmodule
