module regfile(
    input logic clk,
    input logic [4:0] AD1,
    input logic [4:0] AD2,
    input logic [4:0] AD3,
    input logic WE3,
    input logic [31:0] WD3,
    output logic [31:0] RD1,
    output logic [31:0] RD2,
    output logic [31:0] a0
);

logic [31:0] registers[31];

always_ff@(posedge clk)
    if (WE3 && AD3 != 0)
        registers[AD3 - 1] <= WD3;

always_comb
begin
    if(AD1 != 0)
        RD1 = registers[AD1 - 1];
    else
        RD1 = 32'b0;
    if(AD2 != 0)
        RD2 = registers[AD2 - 1];
    else
        RD2 = 32'b0;
    a0 = registers[10 - 1];
end

endmodule
