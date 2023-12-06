module hazard(
    input logic [4:0] Rs1E,
    input logic [4:0] Rs2E,
    input logic [4:0] Rs1D,
    input logic [4:0] Rs2D,
    input logic [4:0] RdM,
    input logic [4:0] RdW,
    input logic [4:0] RdE,
    input logic MemtoRegM,
    input logic MemtoRegE,
    input logic WriteRegE,
    input logic WriteRegM,
    input logic RegWriteM,
    input logic RegWriteW,
    input logic RegwriteE,
    input logic PCSrcE,
    input logic StallF,
    input logic StallD,
    output logic FlushE,
    output logic FlushD,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);

logic lwStall;

//ForwardAE is determined by source reg 1E, so forwards appropriately if matches reg in writeback or mem stage
assign ForwardAE = ((RegWriteW & Rs1E != 0 & RdW == Rs1E)? 2'b10 : (RegWriteM & Rs1E != 0 & RdM == Rs1E) ? 2'b01: 2'b00);
//ForwardBE is determined by source reg 2E so forwards appropriately if matches reg in writeback or mem stage
assign ForwardBE = ((RegWriteW & Rs2E != 0 & RdW == Rs2E)? 2'b10 : (RegWriteM & Rs2E != 0 & RdM == Rs2E) ? 2'b01: 2'b00);

//stall when load hazard occurs
assign lwStall = (((Rs1D == RdE | Rs2D == RdE) & MemtoRegE) ? 1'b1 : 1'b0);
StallF = lwStall;
StallD = lwStall;
//flush when branch is taken or load introduces bubble
FlushD = PCSrcE;
FlushE = (lwStall | PCSrcE);

endmodule
