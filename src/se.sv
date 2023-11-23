module se(
    input logic [31:0] instr,
    input logic ImmSrc,
    output logic ImmOp
);

always_comb
    if(ImmSrc) {
        ImmExt <= {{20(instr[31])}, instr[31:20]};
    } else {
        ImmExt <= {{20(instr[31])}, instr[31:25], instr[11:7]};
    }

endmodule
