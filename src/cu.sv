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
// logic [2:0] func3 = instr[14:12];
// logic [6:0] func7 = instr[31:25];
// logic [11:0] imm12 = instr[31:20];


always_comb begin 
    case(op) 
        // addi instruction 
        7'b0010011:
        begin 
            ImmSrc = 0; //I-Type instruction
            ALUsrc = 1; //Our source value comes from the sign extended Imm (ImmExt) and so select from 1
            ALUctrl = 3'b000; //Add instruction therfore ALUControl=000
            RegWrite = 1;
            PCsrc = 0;
        end 
        // bne instruction
        7'b1100011:
        begin
            ALUsrc = 1; // change
            RegWrite = 0;
            ImmSrc = 1;
            if(EQ)
            begin
                PCsrc = 0;
            end
            else
            begin
                PCsrc = 1; //We want to branch and so we select the branch_pc by setting the select to 1 
                ALUctrl = 3'b001; //Add instruction therfore ALUControl=000
            end
        end
    endcase
end


endmodule
