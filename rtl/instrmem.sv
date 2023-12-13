module instrmem#(
    parameter MEM_SIZE = 4096,
    START_POS = 'hbfc00000
)(
    input logic [31:0] pc,
    output logic [31:0] dout
);

// byte addressable memory
// define data size then NUMBER OF addresses
logic [7:0] mem_array [MEM_SIZE-1:0];

// a fail-safe, ensures you only read from the beginning of a word.
logic[31:0] addr;
assign addr = {pc[31:2], 2'b0} - START_POS;

// reads 4 bytes at a time, starting from the input address
assign dout = {mem_array[addr+3], mem_array[addr+2], mem_array[addr+1],mem_array[addr]};

// initialises memory with the program.
initial
begin
	$display("Loading rom.");
    $readmemh("pdf.hex", mem_array);
end
endmodule
