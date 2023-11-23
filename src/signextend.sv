module signextend #(
    parameter INSTRUCTION_WIDTH = 32
) (
    input logic [INSTRUCTION_WIDTH-1:7] instr
    input logic ImmSrc
    output logic ImmExt
);

always_comb
    if(ImmSrc=0){
        ImmExt<= {{20(instr[31])}, instr[31:20]}
    } else if(ImmSrc=1){
        ImmExt<= {{20(instr[31])}, instr[31:25], instr[11:7]}
    }

endmodule
