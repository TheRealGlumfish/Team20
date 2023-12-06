module hazard(
    input logic [4:0] Rs1E,
    input logic [4:0] Rs2E,
    input logic [4:0] Rs1D,
    input logic [4:0] Rs2D,
    input logic [4:0] RdM,
    input logic [4:0] RdW,
    input logic WriteRegE,
    input logic WriteRegM,
    input logic RegWriteM,
    input logic RegWriteW,
    input logic RegwriteE,
    input logic StallF,
    input logic StallD,
    input logic BranchD,
    input logic MemtoRegM, 
    input logic MemtoRegE,
    input logic BranchD,
    output lofic ForwardAD,
    output logic ForwardBD,
    output logic FlushE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);

logic lwStall;
logic branchstall;

//ForwardAE is determined by source reg 1E, so forwards appropriately if matches reg in writeback or mem stage
assign ForwardAE = ((RegWriteW & Rs1E != 0 & RdW == Rs1E)? 2'b10 : (RegWriteM & Rs1E != 0 & RdM == Rs1E) ? 2'b01: 2'b00);
//ForwardBE is determined by source reg 2E so forwards appropriately if matches reg in writeback or mem stage
assign ForwardBE = ((RegWriteW & Rs2E != 0 & RdW == Rs2E)? 2'b10 : (RegWriteM & Rs2E != 0 & RdM == Rs2E) ? 2'b01: 2'b00);

assign ForwardAD = ((Rs1D != 0 & Rs1D == WriteRegM & RegWriteM) ? 1'b1 : 1'b0);

assign ForwardBD = ((Rs2D != 0 & Rs2D == WriteRegM & RegWriteM) ? 1'b1 : 1'b0);

assign lwStall = (((Rs1D == Rs2E | Rs2D == Rs2E) & MemtoRegE) ? 1'b1 : 1'b0);

assign branchstall = ((BranchD & RegWriteE & (WriteRegE == Rs1D | WriteRegE == Rs2D)) | (BranchD & MemtoRegM & (WriteRegM == Rs1D | WriteRegM == Rs2D))) ? 1'b1: 1'b0;

StallF, StallD = lwStall;
FlushE = (lwStall | branchstall);

endmodule
