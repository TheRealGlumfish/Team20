module cache #(
    parameter SET_LENGTH = 3 // a set length of 3 means 8 cache blocks
)(
    input clk,
    input logic [2:0] DataWidth,
    input cache_en,
    input wen, //memwrite
    input logic [31:0] addr, //[Tag,set,byte_offset]
    input logic [31:0] rdata,
    input logic [31:0] wdata, 
    output logic [31:0] data_out
);

logic [29-SET_LENGTH:0] itag;
logic [SET_LENGTH-1:0] iset;
logic [29-SET_LENGTH:0] ctag;
logic cvalid;
logic aligned;
logic hit;

logic [31:0] cache_line[2**SET_LENGTH];
logic [29-SET_LENGTH:0] cache_tag[2**SET_LENGTH];
logic cache_valid[2**SET_LENGTH];

assign itag = addr[31:SET_LENGTH+2];
assign iset = addr[SET_LENGTH+1:2];
assign ctag = cache_tag[iset];
assign cvalid = cache_valid[iset];

assign aligned = addr[1:0] == 2'b00; 
assign hit = (aligned && ctag == itag && cvalid);

always_comb
if(hit)
    case(DataWidth)    
        3'b000:  // LW
            data_out = cache_line[iset];
        3'b001: // LH
            data_out = {{16{cache_line[iset][7]}}, cache_line[iset][15:0]};
        3'b010: // LB
            data_out = {{24{cache_line[iset][7]}}, cache_line[iset][7:0]};
        3'b101: // LHU
            data_out = {16'b0, cache_line[iset][15:0]};
        3'b110: // LBU
            data_out = {24'b0, cache_line[iset][7:0]};
        default: // default just load word
            data_out = cache_line[iset];
    endcase
else
    data_out = rdata;

always_ff@(posedge clk)
begin
    if(wen && cache_en && aligned)
        case(DataWidth)    
            3'b000:
            begin
                cache_line[iset] <= wdata;
                cache_tag[iset] <= itag;
                cache_valid[iset] <= 1;
            end
            3'b001:
            begin
                cache_line[iset] <= {cache_line[iset][31:16], wdata[15:0]};
                cache_tag[iset] <= itag;
                cache_valid[iset] <= 1;
            end
            3'b010:
            begin
                cache_line[iset] <= {cache_line[iset][31:8], wdata[7:0]};
                cache_tag[iset] <= itag;
                cache_valid[iset] <= 1;
            end
            default: // default just load word
            begin
                cache_line[iset] <= wdata;
                cache_tag[iset] <= itag;
                cache_valid[iset] <= 1;
            end
        endcase
    if(wen && cache_en && !aligned) // if unaligned write, invalidate current set
    begin        
        cache_valid[iset] <= 0;
        if(cache_tag[iset] == cache_tag[iset + 1]) // if two adjacent sets share the same tag, it means they are adjacent words and must be both invalidated
            cache_valid[iset + 1] <= 0;
    end
end

always_ff@(negedge clk)
if(!hit && aligned && cache_en)
begin
    cache_line[iset] <= rdata;
    cache_tag[iset] <= itag;
    cache_valid[iset] <= 1;
end

integer i;
initial
    for (i = 0; i < 2**SET_LENGTH; i++)
        cache_valid[i] = 0; 

endmodule

