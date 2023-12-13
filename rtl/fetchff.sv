module fetchff (
    input logic clk,
    input logic [31:0] instrF,
    input logic [31:0] PCF,
    input logic [31:0] PCPlus4F,
    input logic en,
    input logic clear,
    output logic [31:0] instrD,
    output logic [31:0] PCD,
    output logic [31:0] PCPlus4D
);

always_ff@(posedge clk)
begin

    if(clear)
        begin
            instrD <= 0;
            PCD <= 0;
            PCPlus4D <= 0;
        end
    else if (!en)
        begin
            instrD <= instrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end
end
endmodule


