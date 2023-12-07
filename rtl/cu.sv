module cu(
    input logic [31:0] instr,
    input logic Zero, // TODO: Change to zero
    output logic  PCsrc,
    output logic  JALR,
    output logic [1:0]  ResultSrc,
    output logic  MemWrite,
    output logic  ALUsrc,
    output logic  RegWrite,
    output logic  [2:0] ImmSrc,
    output logic [2:0] ALUctrl,
    output logic Jump
);

logic [6:0] op;
logic [6:0] func7;
logic [2:0] func3;
logic [1:0] ALUop; 
logic Branch;
logic BranchandZero;

assign op = instr[6:0];
assign func7 = instr[31:25];
assign func3 = instr[14:12];

maindecode maindecode(op, Zero, ResultSrc, MemWrite, ALUsrc, ImmSrc, RegWrite, ALUop, Branch, Jump);
ALUDecode ALUDecode(op, func3, func7, ALUop, ALUctrl); 

//If there is a Branch instruction then depending on the func3 field we can identify whether we do a BEQ or BNE and so we want PCsrc=1 if BNE (Branch and ~EQ) and want PCsrc=1 if BEQ (Branch and EQ)
always_comb
begin
    case (func3)
        // beq instruction
        3'b000:
            BranchandZero = Branch & Zero;
        // bne instruction
        3'b001:
            BranchandZero = Branch & ~Zero;
        default:
            BranchandZero = 0; // should never be reached
    endcase
end

//If there is a jump then PCsrc =1 ie, PC source 1 if beq, bne or Jump
assign PCsrc = (BranchandZero | Jump);
assign JALR = op==7'b1100111; //if op==JALR then raise the JALR flag for the PC to take in the aluout value

endmodule
