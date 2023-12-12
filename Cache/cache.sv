module cache#(
    parameter setlength = 3  //a set length of 3 means 8 chache blocks
)
(
    input clk,
    input rst,
    input logic [31:0] addr, //[Tag,set,byte_offset]
    input logic [31:0] datain,
    output logic [31:0] cache_out,
    output logic Hit

);


logic [59:0] cacheblocks [2**setlength-1:0] ; // our set is 3 bits and so at most 8 cache blocks 
//input 
logic [26:0] tag_i = addr[31:setlength+2];
logic [2:0]  set_i = addr[setlength+1:2]; 
//cache
logic v_c = cacheblocks[set_i][59];
logic [26:0] tag_c = cacheblocks[set_i][58:32];
//hit
assign Hit = (v_c && tag_c==tag_i) ;

always_ff @(negedge clk) begin
    if (Hit)begin
        cache_out <= cacheblocks[set_i][31:0];
    end
    else begin
        cacheblocks[set_i][31:0] <= datain ; //assign the data of the address into the cache if there was not a hit
        cacheblocks[set_i][58:32] <= tag_i; //replace the old tag with now the new tag of what we are replacing
        cacheblocks[set_i][59] <=1 ; //cache v bit is now valid (1)
    end
    end
endmodule