module maindecode(
    input logic [6:0] op,
    input logic EQ,
    output logic [1:0] ResultSrc,
    output logic MemWrite,
    output logic ALUsrc,
    output logic [2:0] ImmSrc,
    output logic RegWrite,
    output logic [1:0] ALUop,
    output logic Branch,
    output logic Jump
);

assign RegWrite = (op==7'b0000011 |op==7'b0110011 | op==7'b0010011 | op==7'b1101111) ? 1'b1 : 1'b0;
//If there is a Branch type Then we want to select the  verion of sign extention needed for the branch instruction
//if Branch ImmSrc = 010, if store ImmSrc = 001, if lw or I ImmSrc is 000, if Jump IMmsrc is 011 else 111
assign ImmSrc = ((op==7'b1100011) ? 3'b010 : (op==7'b0100011) ? 3'b001: (op==7'b0000011 | op==7'b0010011)? 3'b000 : (op==7'b1101111 | op==7'b1100111) ? 3'b011: 3'b111);
//If there is a lw or sw or I-type Then we want to the source register (ALUop2) to be the sign extneded immediate value
assign ALUsrc =(op==7'b0000011 |op==7'b0100011 | op==7'b0010011) ? 1'b1 : 1'b0 ;
//If there is a Branch type then we want to branch only when not equal
assign Branch = ((op==7'b1100011)? 1'b1 : 1'b0);
//JAL instruction so jumps 4 when is 0
//assign PCsrc = ((op==7'b1101111)? 1'b0 : 1'b1);
//ALU op logic 2 bits
assign ALUop = (op==7'b1100011) ? 2'b01 : (op==7'b0110011) ? 2'b10 : 2'b00 ;
//Resultsrc logic is 10 if JAL or JALR, is 01 for lw, is 00 for R-type and I-type ALU rest are dontcares (11)
assign ResultSrc = ((op==7'b0000011) ? 2'b01 : (op==7'b0110011 | 7'b0010011) ? 2'b00 : (op==7'b1101111 | op==7'b1100111) ? 2'b10 : 2'b11);
//Memwrite stays 0 unless op is 0100011
assign MemWrite = ((op==7'b0100011) ? 1'b1 : 1'b0);
//Jump instructions    
assign Jump = ((op==7'b1101111 | op==7'b1100111) ? 1'b1 : 1'b0);

endmodule