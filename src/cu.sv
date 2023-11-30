module cu(
    input logic [31:0] instr,
    input logic EQ,
    output logic  PCsrc,
    // output logic  ResultSrc,
    // output logic  MemWrite,
    output logic  ALUsrc,
    output logic  RegWrite,
    output logic  ImmSrc,
    output logic [2:0] ALUctrl
);

logic [6:0] op = instr[6:0];
logic [6:0] func7 = instr[31:25];
logic [2:0] func3 = instr[14:12];
logic Branch;
logic [1:0] ALUOp;

//If there is a lw or R-type or I-type Then we want to write to the registers
assign RegWrite = (op==7'b0000011 |op==7'b0110011 | op==7'b0010011) ? 1'b1 : 1'b0;
//If there is a Branch type Then we want to select the  verion of sign extention needed for the branch instruction
assign ImmSrc = (op==7'b1100011) ? 1'b1 : 0;
//If there is a lw or sw or I-type Then we want to the source register (ALUop2) to be the sign extneded immediate value
assign ALUsrc =(op==7'b0000011 |op==7'b0100011 | op==7'b0010011) ? 1'b1 : 1'b0 ;
//If there is a Branch type then we want to branch only when not equal
assign Branch = ((op==7'b1100011)? 1'b1 : 1'b0);
//If there is a Branch instruction then the ALUctrl value is 001 to indiicate we want to compare, or else it is 000 indicating we add (Only using 2 instructions for Lab-4)q
assign ALUOp = (op==7'b1100011) ? 2'b01 : (op==7'b0110011) ? 2'b10 : 2'b00 ;
//ALU Decode logic, will return the ALUctrl as output
ALUDecode ALUDecode(op,func3,func7,ALUOp,ALUctrl);

//If there is a Branch instruction then depending on the func3 field we can identify whether we do a BEQ or BNE and so we want PCsrc=1 if BNE (Branch and ~EQ) and want PCsrc=1 if BEQ (Branch and EQ)
always_comb begin
    case (func3)
        ///beq instruction
        3'b000:
            assign PCsrc = Branch & EQ ;
        //bne instruction
        3'b001:
            assign PCsrc = Branch & ~EQ ;
    endcase
end
endmodule

