module lab5_1_mealy(input wire clk,rst,x,output wire y,
                   output wire [1:0] state);
    fsm_mealy core(clk,rst,x,state,y);
endmodule

module lab5_2_vending #(
    parameter integer STABLE_CYCLES=500000,
    parameter integer LED_CYCLES=12500000
)(input wire clk,rst,a,b,c,output wire [2:0] state,
  output wire y,output wire vend_pulse);
    wire pa,pb,pc;
    button_onepulse #(STABLE_CYCLES) ba(clk,rst,a,pa);
    button_onepulse #(STABLE_CYCLES) bb(clk,rst,b,pb);
    button_onepulse #(STABLE_CYCLES) bc(clk,rst,c,pc);
    vending_machine core(clk,rst,pa,pb,pc,state,vend_pulse);
    // Human-visible copy; vend_pulse remains the exact Mealy output.
    localparam integer W=(LED_CYCLES<2) ? 1 : $clog2(LED_CYCLES+1);
    reg [W-1:0] visible;
    always @(posedge clk or posedge rst)
        if(rst) visible<=0;
        else if(vend_pulse) visible<=LED_CYCLES;
        else if(visible!=0) visible<=visible-1'b1;
    assign y=(visible!=0);
endmodule

module lab5_3_updown #(
    parameter integer STABLE_CYCLES=500000
)(input wire clk,rst,button,output wire [2:0] count,
  output wire down);
    wire pulse;
    button_onepulse #(STABLE_CYCLES) bp(clk,rst,button,pulse);
    counter_updown3 core(clk,rst,pulse,count,down);
endmodule
