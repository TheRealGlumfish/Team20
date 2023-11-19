module rom #(
    parameter ADDRESS_WIDTH=8,
              DATA_WIDTH=32
)(
    input logic [DATA_WIDTH-1:0]         PC,
    output logic [DATA_WIDTH-1:0]           instr
);

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

assign instr = rom_array[PC[DATA_WIDTH-1:2]];

initial begin
        $display("Loading rom.");
        $readmemh("main.mem",rom_array);
end;
//asynchronous memory therefore not dependant on clk or rst

endmodule
