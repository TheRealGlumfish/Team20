module cache #(
    parameter setlength = 3 // a set length of 3 means 8 cache blocks
)(
    input clk,
    input logic [2:0] DataWidth,
    input cacheEn,
    input wen, //memwrite
    input logic [31:0] addr, //[Tag,set,byte_offset]
    input logic [31:0] ramdata,
    input logic [31:0] wdatain, 
    output logic [31:0] cache_out,
    output logic Hit
);
//TODO : ADD cu signals for chace wheter we have read from mem or write from meme
logic [62-setlength:0] cacheblocks [2**setlength-1:0]; // our set is 3 bits and so at most 8 cache blocks
//input 
logic [29-setlength:0] tag_i = addr[31:setlength+2];
logic [setlength-1:0] set_i = addr[setlength+1:2]; 
//cache
logic v_c = cacheblocks[set_i][62-setlength];
logic [29-setlength:0] tag_c = cacheblocks[set_i][61-setlength:32];

//logic that outputs the value of cache if HIT or value of Ram data if miss
always_comb begin
    if(v_c && tag_c == tag_i) begin
        case(DataWidth)
            3'b000:begin//LW
                cache_out = cacheblocks[set_i][31:0];
            end
            3'b001:begin//LH
                cache_out = {{16{cacheblocks[set_i][15]}},cacheblocks[set_i][15:0]};
            end
            3'b010:begin//LB
                cache_out = {{24{cacheblocks[set_i][7]}},cacheblocks[set_i][7:0]};
            end            
            3'b101:begin//LHU
                cache_out = {16'b0,cacheblocks[set_i][15:0]};
            end            
            3'b110:begin//LBU
                cache_out = {24'b0,cacheblocks[set_i][7:0]};
            end
            default:
                begin
                    cache_out = cacheblocks[set_i][31:0];
                end
        endcase

    end
    else begin
        cache_out = ramdata;
    end
end

//only alter cache if we have a instruction that uses memory/cache
always_ff@(posedge clk)begin
    if(cacheEn) //if we have a cache/ mem type instruction
        if(wen)begin //if we want to write to cache / memory then write regardless (doesn't need a hit)
            case(DataWidth)
                3'b000:begin //sw
                    cacheblocks[set_i][31:0] <= wdatain; // assign word of the data of the address into the cache 
                    cacheblocks[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
                    cacheblocks[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
                end
                3'b001:begin//shw
                cacheblocks[set_i][15:0] <= wdatain[15:0]; // assign half of data of the address into the cache 
                cacheblocks[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
                cacheblocks[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
                end
                3'b010:begin //sb
                cacheblocks[set_i][7:0] <= wdatain[7:0]; // assign byte of data of the address into the cache if there was not a hit
                cacheblocks[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
                cacheblocks[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
                end
            endcase
        end
        if(!(v_c && tag_c == tag_i))begin //if we dont have a hit then get the value at the adress from ram 
            cacheblocks[set_i][31:0] <= ramdata; // assign the data of the address into the cache if there was not a hit
            cacheblocks[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
            cacheblocks[set_i][62-setlength] <= 1; // cache v bit is now valid (1)

        end
end

endmodule
