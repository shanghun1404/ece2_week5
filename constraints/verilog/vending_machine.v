module vending_machine(
    input wire clk, rst, a, b, c,
    output reg [2:0] state,
    output wire y
);
    localparam S0=3'd0, S50=3'd1, S100=3'd2,
               S150=3'd3, S200=3'd4;
    reg [2:0] next_state;
    always @* begin
        next_state = state;
        case (state)
            S0:   if (a) next_state=S50;
                  else if (b) next_state=S100;
            S50:  if (a) next_state=S100;
                  else if (b) next_state=S150;
            S100: if (a) next_state=S150;
                  else if (b) next_state=S200;
            S150: if (a || b) next_state=S200;
            S200: if (c) next_state=S0;
            default: next_state=S0;
        endcase
    end
    always @(posedge clk or posedge rst)
        if (rst) state <= S0;
        else state <= next_state;
    assign y = (state == S200) && c && !rst;
endmodule
