module alu(
    input logic [31:0] ALUop1,
    input logic [31:0] ALUop2,
    input logic ALUctrl,
    output logic [31:0] ALUout,
    output logic EQ
);

always_comb
begin
    ALUout = ALUop1 + ALUop2;
    EQ = ALUop1 == ALUop2;
end 

endmodule
