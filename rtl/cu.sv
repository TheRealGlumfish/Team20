module cu(
    input logic [31:0] instr,
    output logic JALR,
    output logic JAL,
    output logic MemWrite,
    output logic RegWrite,
    output logic Branch,
    output logic ALUsrc,
    output logic [1:0]  ResultSrc,
    output logic [2:0] ImmSrc,
    output logic [3:0] ALUctrl,
    output logic [2:0] DataWidth,
    output logic [2:0] funct3
);

logic [6:0] op;
logic [6:0] funct7;

assign op = instr[6:0];
assign funct7 = instr[31:25];
assign funct3 = instr[14:12];
assign JALR = op == 7'b1100111;
assign JAL = op == 7'b1101111;

always_comb
begin
    case(op)
        7'b0110011: // R-Type instructions
        begin
            Branch = 0;
            ResultSrc = 2'b00; // read from ALU
            MemWrite = 0;
            ALUsrc = 0;
            ImmSrc = 3'b000; // Don't care
            RegWrite = 1;
            ALUctrl = {funct7[5], funct3}; 
            DataWidth = 3'b000;
        end
        7'b0000011: // I-Type instructions (load)
        begin
           Branch = 0;
           ResultSrc = 2'b01; // read from datamem
           MemWrite = 0;
           ALUsrc = 1;
           ImmSrc = 3'b000;
           RegWrite = 1;
           ALUctrl = 4'b0000;
           case(funct3)
                3'b000: // load byte
                    DataWidth = 3'b010;
                3'b001: // load half
                    DataWidth = 3'b001;
                3'b010: // load word
                    DataWidth = 3'b000;
                3'b100: // load byte unsigned
                    DataWidth = 3'b110;
                3'b101: // load half unsigned
                    DataWidth = 3'b101;
                default:
                    DataWidth = 3'b000;
           endcase
        end
        7'b0010011: // I-Type instructions (arithmetic)
        begin
            Branch = 0;
            ResultSrc = 2'b00; // read from ALU
            MemWrite = 0;
            ALUsrc = 1;
            ImmSrc = 3'b000;
            RegWrite = 1;
            ALUctrl = (funct3 == 3'b101) ? {funct7[5], funct3} : {1'b0, funct3}; 
            DataWidth = 3'b000;
        end
        7'b1100111: // I-Type instructions (jalr)
        begin
            Branch = 1;
            ResultSrc = 2'b10;
            MemWrite = 0;
            ALUsrc = 1;
            ImmSrc = 3'b000;
            RegWrite = 1;
            ALUctrl = 4'b0000;
            DataWidth = 3'b000;
        end
        7'b0100011: // S-Type instructions
        begin
            Branch = 0;
            ResultSrc= 2'b00; // Don't care
            MemWrite = 1;
            ALUsrc = 1;
            ImmSrc = 3'b001;
            RegWrite = 0;
            ALUctrl = 4'b0000;
            case(funct3)
                3'b000: // store byte
                    DataWidth = 3'b010;
                3'b001: // store half
                    DataWidth = 3'b001;
                3'b010: // store word
                    DataWidth = 3'b000;
                default:
                    DataWidth = 3'b000;
            endcase
        end
        7'b1100011: // B-Type instructions
        begin
            Branch = 1;
            ResultSrc = 2'b00;
            MemWrite = 0;
            ALUsrc = 0;
            ImmSrc = 3'b010;
            RegWrite = 0;
            DataWidth = 3'b000;
            case(funct3)
                3'b000: // beq
                begin
                    ALUctrl = 4'b1000;
                end
                3'b001: // bne
                begin
                    ALUctrl = 4'b1000;
                end
                3'b100: // blt
                begin
                    ALUctrl = 4'b0011;
                end
                3'b101: // bge
                begin
                    ALUctrl = 4'b0010;
                end
                3'b110: // bltu
                begin
                    ALUctrl = 4'b0011;
                end
                3'b111: // bgeu
                begin
                    ALUctrl = 4'b0011;
                end
		default:
		begin
		    ALUctrl = 4'b0000;
		end
            endcase
        end
        // 7'b0010111: // U-Type instructions (auipc)
        // begin
        // 
        // end
        7'b0110111: // U-Type instructions (lui)
        begin
            Branch = 0;
            ResultSrc = 2'b00;
            MemWrite = 0;
            ALUsrc = 1; 
            ImmSrc = 3'b100;
            RegWrite = 1;
            ALUctrl = 4'b1001;
            DataWidth = 3'b000;
        end
        7'b1101111: // J-Type instructions (jal)
        begin
           Branch = 1;
           ResultSrc = 2'b10;
           MemWrite = 0;
           ALUctrl = 4'b0000; // possibly don't care?
           ALUsrc = 1;
           ImmSrc = 3'b011; // check possibly disable?
           RegWrite = 1;
           DataWidth = 3'b000;
        end
	default:
	begin
        Branch = 0;
	    ResultSrc = 2'b00;
	    MemWrite = 0;
	    ALUctrl = 4'b0000;
	    ALUsrc = 1;
	    ImmSrc = 3'b000;
	    RegWrite = 0;
	    DataWidth = 3'b000;
	end
    endcase
end

endmodule
