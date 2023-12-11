module datamem#(
    parameter MEM_SIZE = 131072,
    USABLE_MEM_START = 'h10000
)(
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic wen,
    input logic [2:0] DataWidth,
    output logic [31:0] dout
);

// byte-addressed memory
logic [7:0] mem_array [MEM_SIZE-1:0];
logic [31:0] wdata_padded;

always_comb
begin
    case(DataWidth)    
        3'b000:  // LW
            begin
                dout = {mem_array[addr+3], mem_array[addr+2], mem_array[addr+1], mem_array[addr]};
                wdata_padded = wdata;
            end
        3'b001: // LH
            begin
                dout = {{16{mem_array[addr+1][7]}}, mem_array[addr+1], mem_array[addr]};
                wdata_padded = {16'b0, wdata[15:0]};
            end
        3'b10: // LB
            begin
                dout = {{24{mem_array[addr][7]}}, mem_array[addr]};
                wdata_padded = {24'b0, wdata[7:0]};
            end

        3'b101: // LHU
            begin
                dout = {16'b0, mem_array[addr+1], mem_array[addr]};
                wdata_padded = {16'b0, wdata[15:0]};
            end

        3'b10: // LBU
            begin
                dout = {24'b0, mem_array[addr]};
                wdata_padded = {24'b0, wdata[7:0]};
            end

        default: // default just load word
            begin
                dout = {mem_array[addr+3], mem_array[addr+2], mem_array[addr+1], mem_array[addr]};
                wdata_padded = wdata;
            end
    endcase
end



always_ff @(posedge clk)
begin
	if(wen)
    begin
		mem_array[addr] <= wdata_padded[7:0];
        mem_array[addr+1] <= wdata_padded[15:8];
        mem_array[addr+2] <= wdata_padded[23:16];
        mem_array[addr+3] <= wdata_padded[31:24];
    end
end

initial
begin
	$display("Loading data memory.");
    $readmemh("gaussian.mem", mem_array, USABLE_MEM_START);
end

endmodule
