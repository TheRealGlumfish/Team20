module se(
    input logic [31:0] instr,
    input logic [1:0] ImmSrc,
    output logic [31:0] ImmOp
);

always_comb
    begin
        case(ImmSrc)
        2'b00:
            assign ImmOp = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        2'b01:
            assign ImmOp = {{20{instr[31]}}, instr[31:20]};
        2'b10:
            assign ImmOp = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        endcase
    end
endmodule
