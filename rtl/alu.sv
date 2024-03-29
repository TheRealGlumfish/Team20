module alu(
    input logic [31:0] ALUop1,
    input logic [31:0] ALUop2,
    input logic [3:0] ALUctrl,
    output logic [31:0] ALUout,
    output logic Zero
);

logic signed [31:0] ALUop1_signed;
assign ALUop1_signed = ALUop1;

always_comb
begin
    case(ALUctrl)
        4'b0000: // add  
            ALUout = ALUop1 + ALUop2;
        4'b1000: // subtract
            ALUout = ALUop1 - ALUop2;
        4'b0001: // logical shift left
            ALUout = ALUop1 << ALUop2[4:0];
        4'b0010: // less than
        begin
            if(ALUop1[31] == ALUop2[31]) // if both negative or both negative
                ALUout = {31'b0, ALUop1 < ALUop2};
            else
                ALUout = {31'b0, ALUop1[31]};
        end
        4'b0011: // less than unsigned
            ALUout = {31'b0, ALUop1 < ALUop2};
        4'b0100: // bitwise XOR
            ALUout = ALUop1 ^ ALUop2;
        4'b0101: // logical shift right
            ALUout = ALUop1 >> ALUop2[4:0];
        4'b1101: // arithmetic shift right
            ALUout = ALUop1_signed >>> ALUop2[4:0];
        4'b0110: // bitwise OR
            ALUout = ALUop1 | ALUop2;
        4'b0111: // bitwise AND
            ALUout = ALUop1 & ALUop2;
        4'b1001: // LUI instruction
            ALUout = ALUop2;
        default: // should be unreachable
            ALUout = 32'hDEAD; // error magic number
    endcase
    Zero = ALUout == 0;
end

endmodule

