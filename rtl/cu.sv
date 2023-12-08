module cu(
    input logic [31:0] instr,
    input logic Zero,
    output logic JALR,
    output logic MemWrite,
    output logic RegWrite,
    output logic PCsrc,
    output logic ALUsrc,
    output logic [1:0]  ResultSrc,
    output logic [2:0] ImmSrc,
    output logic [3:0] ALUctrl
);

logic [6:0] op;
logic [6:0] funct7;
logic [2:0] funct3;

assign op = instr[6:0];
assign funct7 = instr[31:25];
assign funct3 = instr[14:12];
assign JALR = 0;

always_comb
begin
    case(op)
        7'b0110011: // R-Type instructions
        begin
            PCsrc = 0;
            ResultSrc = 2'b00; // read from ALU
            MemWrite = 0;
            ALUsrc = 0;
            ImmSrc = 3'b000; // Don't care
            RegWrite = 1;
            ALUctrl = {funct7[5], funct3}; 
        end
        7'b0000011: // I-Type instructions (load)
        begin
           PCsrc = 0;
           ResultSrc = 2'b01; // read from datamem
           MemWrite = 0;
           ALUsrc = 1;
           ImmSrc = 3'b000;
           RegWrite = 1;
           ALUctrl = 4'b0000;
        end
        7'b0010011: // I-Type instructions (arithmetic)
        begin
            PCsrc = 0;
            ResultSrc = 2'b00; // read from ALU
            MemWrite = 0;
            ALUsrc = 1;
            ImmSrc = 3'b000;
            RegWrite = 1;
            ALUctrl = {funct7[5], funct3}; 
        end
        7'b0100011: // S-Type instructions
        begin
            PCsrc = 0;
            ResultSrc= 2'b00; // Don't care
            MemWrite = 1;
            ALUsrc = 1;
            ImmSrc = 3'b000;
            RegWrite = 0;
            ALUctrl = 4'b0000;
            // case(funct3)
            //     3'b000: // store byte
            //
            //     3'b001: // store half
            //
            //     3'b010: // store word
            //
            // endcase
        end
        7'b1100011: // B-Type instructions
        begin
            ResultSrc = 2'b00;
            MemWrite = 0;
            ALUsrc = 0;
            ImmSrc = 3'b010;
            RegWrite = 0;
            case(funct3)
                3'b000: // beq
                begin
                    PCsrc = Zero;
                    ALUctrl = 4'b1001;
                end
                3'b001: // bne
                begin
                    PCsrc = !Zero;
                    ALUctrl = 4'b1001;
                end
                3'b100: // blt
                begin
                    PCsrc = !Zero;
                    ALUctrl = 4'b0011;
                end
                3'b101: // bge
                begin
                    PCsrc = Zero;
                    ALUctrl = 4'b0010;
                end
                3'b110: // bltu
                begin
                    PCsrc = !Zero;
                    ALUctrl = 4'b0011;
                end
                3'b111: // bgeu
                begin
                    PCsrc = Zero;
                    ALUctrl = 4'b0011;
                end
            endcase
        end
    endcase
end

endmodule
