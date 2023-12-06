module maindecode(
    input logic [6:0] op,
    input logic EQ,
    output logic PCsrc,
    output logic ResultSrc,
    output logic MemWrite,
    output logic ALUsrc,
    output logic [1:0] ImmSrc,
    output logic RegWrite,
    output logic [1:0] ALUop
);

logic Branch;

assign RegWrite = (op==7'b0000011 |op==7'b0110011 | op==7'b0010011) ? 1'b1 : 1'b0;
//If there is a Branch type Then we want to select the  verion of sign extention needed for the branch instruction
assign ImmSrc = ((op==7'b1100011) ? 2'b10 : (op==7'b0100011) ? 2'b01: 2'b00);
//If there is a lw or sw or I-type Then we want to the source register (ALUop2) to be the sign extneded immediate value
assign ALUsrc =(op==7'b0000011 |op==7'b0100011 | op==7'b0010011) ? 1'b1 : 1'b0 ;
//If there is a Branch type then we want to branch only when not equal
assign Branch = ((op==7'b1100011)? 1'b1 : 1'b0);
//JAL instruction so jumps 4 when is 0
assign PCsrc = ((op==7'b1101111)? 1'b0 : 1'b1);
//ALU op logic 2 bits
assign ALUop = (op==7'b1100011) ? 2'b01 : (op==7'b0110011) ? 2'b10 : 2'b00 ;
//Resultsrc logic
assign ResultSrc = ((op==7'b0000011) ? 1'b1 : 1'b0);
//Memwrite stays 0 unless op is 0100011
assign MemWrite = ((op==7'b0100011) ? 1'b1 : 1'b0);

endmodule
