module datamem(
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic wen,
    output logic [31:0] dout,
);

// byte-addressed memory
logic [7:0] mem_array [512:0];

always_ff @(posedge clk)
    begin
        if(wen) mem_array[addr] <= wdata;
        dout <= {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
    end

initial begin
        $display("Loading rom.");
        $readmemh("main.mem", mem_array);
end;

endmodule
