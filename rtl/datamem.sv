module datamem#(
    parameter MEM_SIZE = 131072,
    USABLE_MEM_START = 'h10000
)(
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic wen,
    input logic [1:0] DataWidth,
    output logic [31:0] dout
);

// byte-addressed memory
logic [7:0] mem_array [MEM_SIZE-1:0];
logic [31:0] wdata_padded;

always_comb
begin
    case(DataWidth)
        2'b00:  // word from memory
            begin
                dout = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
                wdata_padded = wdata;
            end
        2'b01: // half word from memory (2 LSB's)
            begin
                dout = {16'b0, mem_array[addr+2], mem_array[addr+3]};
                wdata_padded = {16'b0, wdata[15:0]};
            end
        2'b10: // LSB byte from memory
            begin
                dout = {24'b0, mem_array[addr+3]};
                wdata_padded = {24'b0, wdata[7:0]};
            end
        default:
            begin
                dout = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
                wdata_padded = wdata;
            end
    endcase
end



always_ff @(posedge clk)
begin
	if(wen)
    begin
		mem_array[addr+3] <= wdata_padded[7:0];
        mem_array[addr+2] <= wdata_padded[15:8];
        mem_array[addr+1] <= wdata_padded[23:16];
        mem_array[addr] <= wdata_padded[31:24];
    end
end

initial
begin
	$display("Loading data memory.");
   $readmemh("triangle.mem", mem_array, USABLE_MEM_START);
end

endmodule
