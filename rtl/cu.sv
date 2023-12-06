module cu(
    input logic [31:0] instr,
    input logic Zero, // TODO: Change to zero
    output logic  PCsrc,
    output logic  ResultSrc,
    output logic  MemWrite,
    output logic  ALUsrc,
    output logic  RegWrite,
    output logic  [1:0] ImmSrc,
    output logic [2:0] ALUctrl
);

logic [6:0] op;
logic [6:0] func7;
logic [2:0] func3;
logic [1:0] ALUop; 
logic Branch;

assign op = instr[6:0];
assign func7 = instr[31:25];
assign func3 = instr[14:12];

maindecode maindecode(op, Zero, ResultSrc, MemWrite, ALUsrc, ImmSrc, RegWrite, ALUop, Branch);
ALUDecode ALUDecode(op, func3, func7, ALUop, ALUctrl); 

//If there is a Branch instruction then depending on the func3 field we can identify whether we do a BEQ or BNE and so we want PCsrc=1 if BNE (Branch and ~EQ) and want PCsrc=1 if BEQ (Branch and EQ)
always_comb
begin
    case (func3)
        // beq instruction
        3'b000:
            PCsrc = Branch & Zero;
        // bne instruction
        3'b001:
            PCsrc = Branch & ~Zero;
        default:
            PCsrc = 0; // should never be reached
    endcase
end

endmodule
