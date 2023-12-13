module hazard(
    input logic [4:0] Rs1E,
    input logic [4:0] Rs2E,
    input logic [4:0] Rs1D,
    input logic [4:0] Rs2D,
    input logic [4:0] RdM,
    input logic [4:0] RdW,
    input logic [4:0] RdE,

    input logic MemtoRegE, // first bit of resultSrcE

    input logic RegWriteM,
    input logic RegWriteW,
    input logic PCSrcE,


    output logic StallF,
    output logic StallD,
    output logic FlushE,
    output logic FlushD,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);

// intermediate signal
logic lwStall;

always_comb
begin
    // assign Forward AE
    if (RegWriteW & Rs1E != 0 & RdW == Rs1E)
        ForwardAE = 2'b10;
    else if(RegWriteM & Rs1E != 0 & RdM == Rs1E)
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;

    // assign ForwardBE
    if(RegWriteW & Rs2E != 0 & RdW == Rs2E)
        ForwardBE = 2'b10;
    else if (RegWriteM & Rs2E != 0 & RdM == Rs2E)
        ForwardBE = 2'b01;
    else
        ForwardBE = 2'b00;

    // assign lwStall
    lwStall = ((Rs1D == RdE | Rs2D == RdE) & MemtoRegE);
    StallF = lwStall;
    StallD = lwStall;

    // assign flush signals
    FlushD = PCSrcE;
    FlushE = (lwStall | PCSrcE);
end

endmodule
