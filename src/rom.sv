module rom#(
    parameter NUM_ADDRESSES=10 //we have 2^10 memory locations (addresses)
)(
    input logic [31:0]  PC, //current program counter
    output logic [31:0] instr //the instruction at this PC value
);

logic [31:0] rom_array [2**NUM_ADDRESSES-1:0]; /* allocate a rom array (only should read instruction mem and never write to it so we dont use RAM) 
of size 8 bits in each mem location, and we have 2^10 of these  8 bit locations (same as having 2^8=256 32 bit memory locations)*/

// ignore the last 2 bits of our pc, since we need to make this byte addressed
logic [31:0] addr = {PC[31:2], 2'b0};

/*
Byte addressing - Each instruction is made of 4 addresses, and these
addresses are offsets of the addr value, where we offset by values:
- 0 : byte 0
- 1 : byte 1
- 2 : byte 2
- 3 : byte 3

and through the concatenation of these bytes, we reconstruct our original instruction
*/

// The memory file is read from left to right, and so the byte of offset 0 (byte 1) corresponds to the MSB and the byte of offset 3 (byte 4) is the LSB
assign instr = {rom_array[addr],rom_array[addr+1], rom_array[addr+2],rom_array[addr+3]};


initial begin
        $display("Loading rom.");
        $readmemh("main.mem", rom_array);
end;
// asynchronous memory therefore not dependant on clk or rst

endmodule
