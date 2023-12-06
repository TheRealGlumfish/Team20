module datamem(
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic wen,
    output logic [31:0] dout,
);

// byte-addressed memory
logic [7:0] mem_array [131071:0];

always_ff @(posedge clk)
    begin
        if(wen)
            begin
                mem_array[addr] <= wdata[0:7];
                mem_array[addr+1] <= wdata[8:15];
                mem_array[addr+2] <= wdata[16:23];
                mem_array[addr+3] <= wdata[24:31];
            end

        dout <= {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
    end

initial begin
        $display("Loading rom.");
        $readmemh("main.mem", mem_array);
end;

endmodule
