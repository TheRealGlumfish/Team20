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

reg [31:0] registers[32];

always_ff@(posedge clk)
begin
    RD1 <= registers[AD1];
    RD2 <= registers[AD2];
    if (WE3)
        registers[AD3] <= WD3;
    a0 <= registers[0];
end

endmodule
