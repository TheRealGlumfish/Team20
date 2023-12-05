module cu(
    input logic [31:0] instr,
    input logic EQ,
    output logic  PCsrc,
    output logic  ResultSrc,
    output logic  MemWrite,
    output logic  ALUsrc,
    output logic  RegWrite,
    output logic  ImmSrc,
    output logic [2:0] ALUctrl
);

logic [6:0] op = instr[6:0];
logic [6:0] func7 = instr[31:25];
logic [2:0] func3 = instr[14:12];
logic [1:0] ALUop; 
logic Branch;

maindecode maindecode(op, EQ, PCsrc, ResultSrc, MemWrite, ALUsrc, ImmSrc, RegWrite,ALUop);
ALUDecode ALUDecode(op, func3, func7, ALUop, ALUctrl); 

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
