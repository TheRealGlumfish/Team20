module datamem#(
    parameter MEM_SIZE = 131072,
    parameter USABLE_MEM_START = 'h10000
)(
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic wen,
    input logic [2:0] DataWidth,
    input logic [31:0] ioin1,
    input logic [31:0] ioin2,
    output logic [31:0] dout
);

// byte-addressed memory
logic [7:0] mem_array [MEM_SIZE-1:0];

always_comb
begin
    if(addr > 32'hBFC00FFF)
    begin
        if(addr == 32'hFFFFFFFF) 
            dout = ioin1;
        else // should be used with 0xFFFFFFDF
            dout = ioin2;
    end
    else
    case(DataWidth)    
        3'b000:  // LW
            begin
                dout = {mem_array[addr+3], mem_array[addr+2], mem_array[addr+1], mem_array[addr]};
            end
        3'b001: // LH
            begin
                dout = {{16{mem_array[addr+1][7]}}, mem_array[addr+1], mem_array[addr]};
            end
        3'b010: // LB
            begin
                dout = {{24{mem_array[addr][7]}}, mem_array[addr]};
            end

        3'b101: // LHU
            begin
                dout = {16'b0, mem_array[addr+1], mem_array[addr]};
            end

        3'b110: // LBU
            begin
                dout = {24'b0, mem_array[addr]};
            end

        default: // default just load word
            begin
                dout = {mem_array[addr+3], mem_array[addr+2], mem_array[addr+1], mem_array[addr]};
            end
    endcase
end



always_ff @(posedge clk)
begin
	if(wen)
    begin
        case(DataWidth)
            3'b010: // SB
		        mem_array[addr] <= wdata[7:0];
            3'b001:
            begin
                mem_array[addr] <= wdata[7:0];
                mem_array[addr+1] <= wdata[15:8];
            end
            3'b000:
            begin
                mem_array[addr] <= wdata[7:0];
                mem_array[addr+1] <= wdata[15:8];
                mem_array[addr+2] <= wdata[23:16];
                mem_array[addr+3] <= wdata[31:24];
            end
            default:
            begin
                mem_array[addr] <= wdata[7:0];
                mem_array[addr+1] <= wdata[15:8];
                mem_array[addr+2] <= wdata[23:16];
                mem_array[addr+3] <= wdata[31:24];
            end

        endcase
    end
end

initial
begin
	$display("Loading data memory.");
    $readmemh("../tb/gaussian.mem", mem_array, 'h10000);
end

endmodule
