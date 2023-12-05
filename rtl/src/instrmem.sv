module instrmem(
    input logic [31:0] pc,
    output logic [31:0] dout
);

// byte addressable memory
// define data size then NUMBER OF addresses
logic [7:0] mem_array [512:8];

// a fail-safe, ensures you only read from the beginning
// of a word.
logic [31:0] addr = {pc[31:2], 2'b0};

assign dout = {mem_array[addr], mem_array[addr+1], mem_array[addr+2],mem_array[addr+3]};

// initialises memory with the program.
initial begin
        $display("Loading rom.");
        $readmemh("main.mem", mem_array);
end;
endmodule
