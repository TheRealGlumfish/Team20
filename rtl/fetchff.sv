module fetchff (
    input logic clk,
    input logic [31:0] instrF,
    input logic [31:0] PCF,
    input logic [31:0] PCPlus4F,
    output logic [31:0] instrD,
    output logic [31:0] PCD,
    output logic [31:0] PCPlus4D
);

always_ff@(posedge clk)
begin
    instrD <= instrF;
    PCD <= PCF;
    PCPlus4D <= PCPlus4F;
end
endmodule


