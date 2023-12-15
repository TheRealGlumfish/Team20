module cache #(
    parameter setlength = 2 // a set length of 2 means 4 cache blocks
)(
    input clk,
    input logic [2:0] DataWidth,
    input cacheEn,
    input wen, //memwrite
    input logic [31:0] addr, //[Tag,set,byte_offset]
    input logic [31:0] ramdata,
    input logic [31:0] wdatain, 
    output logic [31:0] cache_out
);
logic [62-setlength:0] cacheblocks1 [2**setlength-1:0]; // our set is 2 bits and so at most 4 cache blocks
logic [62-setlength:0] cacheblocks2 [2**setlength-1:0]; // our set is 2 bits and so at most 4 cache blocks
//input 
logic [29-setlength:0] tag_i = addr[31:setlength+2];
logic [setlength-1:0] set_i = addr[setlength+1:2]; 
//cache
logic v_c1 ;
logic v_c2 ;
logic [29-setlength:0] tag_c1 ;
logic [29-setlength:0] tag_c2 ;
logic Hit;
logic Hit1;
logic Hit0;

assign v_c1 = cacheblocks1[set_i][62-setlength];
assign v_c2 = cacheblocks2[set_i][62-setlength];
assign tag_c1 = cacheblocks1[set_i][61-setlength:32];
assign tag_c2 = cacheblocks1[set_i][61-setlength:32];
assign Hit0 = (v_c2 && tag_c2 == tag_i);
assign Hit1 = (v_c1 && tag_c1 == tag_i);
assign Hit = (Hit1 | Hit0);

//logic that outputs the value of cache if HIT or value of Ram data if miss
always_comb begin
    if(Hit) begin
        case(DataWidth)
            3'b000:begin//LW
                assign cache_out = Hit1 ? cacheblocks2[set_i][31:0] : cacheblocks1[set_i][31:0]; //if Hit1 = 0, from blocks 2. If Hit1= 1, from blocks 1
            end
            3'b001:begin//LH
                assign cache_out = Hit1 ? {{16{cacheblocks2[set_i][15]}},cacheblocks2[set_i][15:0]} : {{16{cacheblocks1[set_i][15]}},cacheblocks1[set_i][15:0]};
            end
            3'b010:begin//LB
                assign cache_out = Hit1 ? {{24{cacheblocks2[set_i][7]}},cacheblocks2[set_i][7:0]}: {{24{cacheblocks1[set_i][7]}},cacheblocks1[set_i][7:0]};
            end            
            3'b101:begin//LHU
                assign cache_out = Hit1 ? {16'b0,cacheblocks2[set_i][15:0]} : {16'b0,cacheblocks1[set_i][15:0]};
            end            
            3'b110:begin//LBU
                assign cache_out = Hit1 ? {24'b0,cacheblocks2[set_i][7:0]} : {24'b0,cacheblocks1[set_i][7:0]};
            end
            default:
                begin
                    assign cache_out = Hit1? cache_out = cacheblocks2[set_i][31:0] : cacheblocks1[set_i][31:0];
                end
        endcase

    end
    else begin//miss
        cache_out = ramdata;

    end
end

//only alter cache if we have a instruction that uses memory/cache
always_ff@(posedge clk)begin
    if(cacheEn) //if we have a cache/  mem type instruction 
        if(wen)begin
        case(DataWidth)
            3'b000:begin //sw
                cacheblocks1[set_i][31:0] <= wdatain; // assign word of the data of the address into the cache 
                cacheblocks1[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
                cacheblocks1[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
                cacheblocks2[set_i][31:0] <= wdatain; 
                cacheblocks2[set_i][61-setlength:32] <= tag_i; 
                cacheblocks2[set_i][62-setlength] <= 1;
            end
            3'b001:begin//shw
                cacheblocks1[set_i][15:0] <= wdatain[15:0]; // assign half of data of the address into the cache 
                cacheblocks1[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
                cacheblocks1[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
                cacheblocks2[set_i][15:0] <= wdatain[15:0];
                cacheblocks2[set_i][61-setlength:32] <= tag_i; 
                cacheblocks2[set_i][62-setlength] <= 1;
            end
            3'b010:begin //sb
                cacheblocks1[set_i][7:0] <= wdatain[7:0]; // assign byte of data of the address into the cache if there was not a hit
                cacheblocks1[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
                cacheblocks1[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
                cacheblocks2[set_i][7:0] <= wdatain[7:0];
                cacheblocks2[set_i][61-setlength:32] <= tag_i; 
                cacheblocks2[set_i][62-setlength] <= 1;
            end
        endcase
    end
end
//if we miss write in negdge (to avoid the issues of the delayed by one clk signal tags)
always_ff@(negedge clk)begin    
    if(!Hit)begin
        //we missed and so we have to store the value of ram into cache
        cacheblocks1[set_i][31:0] = ramdata; // assign the ram data of the address into the cache if there was not a hit
        cacheblocks1[set_i][61-setlength:32] = tag_i; // replace the old tag with now the new tag of what we are replacing
        cacheblocks1[set_i][62-setlength] = 1; // cache v bit is now valid (1)
        cacheblocks2[set_i][31:0] = ramdata; 
        cacheblocks2[set_i][61-setlength:32] = tag_i;
        cacheblocks2[set_i][62-setlength] = 1; 
    end
end
endmodule
