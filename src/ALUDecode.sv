module ALUDecode (
    input logic [6:0] op,
    input logic [2:0] func3,
    input logic [6:0] func7,
    input logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

///we are not using ALUControl value 3'b111 and so I'll use it as the defualt
//value if there is no chnage to ALUControl - will not affect ALU aslong as
//ALU doesn't use it 
assign ALUControl = (ALUOp==2'b00) ? 3'b000 : (ALUOp==2'b01) ? 3'b001 : 3'b111 ;

logic [1:0] op5func7={op[5],func7[5]};

always_comb begin
    case(ALUOp)
        2'b00: 
            assign ALUControl =  3'b000 ;
        2'b01:
            assign ALUControl = 3'b001 ;
        2'b10:
            case(func3)
                3'b000: //add (func3=000 and op[5]fucn7[5] = 00 or 01 or 10) and subtract (func3=000 and op[5]func7[5]=11)
                    assign ALUControl = (op5func7==2'b00 | op5func7==2'b01 | op5func7==2'b10) ? 3'b000 : (op5func7==2'b11) ? 3'b001 : 3'b111 ;
                3'b010:
                    assign ALUControl = 3'b101 ; //set less than
                3'b110:
                    assign ALUControl = 3'b011 ; //or
                3'b111:
                    assign ALUControl = 3'b010 ; //and
            endcase
        default:
            ///Never use this value of ALUControl so we'll use it if there are no matches
            ALUControl=3'b111 ;
    endcase
end

endmodule

