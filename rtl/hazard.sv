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
    input logic JALRE,
    // Dimitris you can't run
    // If you don't hand yourself in by 6pm tomorrow evening
    // I will release the documents
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
    // assign ForwardAE
    if(((Rs1E==RdM) & RegWriteM) & (Rs1E!=0))
        ForwardAE = 2'b10;
    else if(((Rs1E==RdW) & RegWriteW) & (Rs1E!=0))
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;

    // assign ForwardBE
    if(((Rs2E==RdM) & RegWriteM) & (Rs2E!=0))
        ForwardBE = 2'b10;
    else if(((Rs2E==RdW) & RegWriteW) & (Rs2E!=0))
        ForwardBE = 2'b01;
    else
        ForwardBE = 2'b00;

    // assign lwStall
    lwStall = ((Rs1D == RdE | Rs2D == RdE) & MemtoRegE);
    StallF = lwStall;
    StallD = lwStall;

    // assign flush signals
    FlushD = (PCSrcE | JALRE);
    FlushE = (lwStall | PCSrcE);
end

endmodule
