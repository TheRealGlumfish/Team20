module datamem(
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic wen,
    output logic [31:0] dout
);

// byte-addressed memory
logic [7:0] mem_array [131071:0];

assign dout = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};

always_ff @(posedge clk)
begin
	if(wen)
    begin
		mem_array[addr] <= wdata[7:0];
        mem_array[addr+1] <= wdata[15:8];
        mem_array[addr+2] <= wdata[23:16];
        mem_array[addr+3] <= wdata[31:24];
    end
end

initial
begin
	$display("Loading data memory.");
   $readmemh("sinerom.mem", mem_array);
end

endmodule
