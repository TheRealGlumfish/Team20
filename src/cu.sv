module cu(
    input logic [31:0] instr,
    input logic Zero,
    output logic  PCSrc,
    output logic  ResultSrc,
    output logic  MemWrite,
    output logic  ALUSrc,
    output logic  RegWrite,
    output logic  ImmSrc,
    output logic [2:0] ALUControl
);

logic [6:0] op = instr[6:0];
logic [2:0] func3 = instr[14:12];
logic [6:0] func7 = instr[31:25];
logic [11:0] imm12 = instr[31:20];


always_comb begin 
    case(op) 
        // addi instruction 
        7'b0010011: begin 
            ImmSrc = 2'b00; //I-Type instruction
            ALUSrc = 1; //Our source value comes from the sign extended Imm (ImmExt) and so select from 1
            ALUControl = 3'b000; //Add instruction therfore ALUControl=000
        end 
        // bne instruction
        7'b1100011: begin
            if(Zero) 
                ImmSrc = 2'b10;
                PCSrc = 1; //We want to branch and so we select the branch_pc by setting the select to 1 
                ALUControl = 3'b001; //Add instruction therfore ALUControl=000
            if(~Zero)
                PCSrc = 0;
                ImmSrc = 1;
            end
    endcase
end


endmodule

