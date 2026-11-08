`timescale 1ns/1ps
module tb_week5;
reg clk=0;
always #5 clk=~clk;
reg rst=1, x=0, a=0, b=0, c=0, en=0;
wire [1:0] state, up;
wire [2:0] credit, ud;
wire y, vend, down;
fsm_mealy f(clk,rst,x,state,y);
vending_machine v(clk,rst,a,b,c,credit,vend);
counter_up2 u(clk,rst,en,up);
counter_updown3 d(clk,rst,en,ud,down);
integer checks=0;
task ck(input bit ok, input string msg);
begin
 checks=checks+1;
 if(!ok) $fatal(1,"FAIL: %s at %0t",msg,$time);
end endtask
task reset_all;
begin @(negedge clk); rst=1; x=0;a=0;b=0;c=0;en=0;
 #1; ck(state===0 && credit===0 && up===0 && ud===0,"reset");
 @(negedge clk); rst=0;
end endtask
task step_f(input bit xi, input [1:0] before_s, after_s, input bit yi);
begin @(negedge clk); x=xi; #1;
 ck(state===before_s && y===yi,"Mealy pre-edge state/output");
 @(posedge clk); #1; ck(state===after_s,"Mealy next state");
end endtask
task coin(input [2:0] abc, input [2:0] expected_s, input bit expected_y);
begin @(negedge clk); {a,b,c}=abc; #1; ck(vend===expected_y,"vending output");
 @(posedge clk); #1; ck(credit===expected_s,"vending credit");
 @(negedge clk); {a,b,c}=0;
end endtask
integer i;
integer seq[0:15]='{1,2,3,4,5,6,7,6,5,4,3,2,1,0,1,2};
initial begin
 reset_all();
 step_f(0,0,0,0); step_f(1,0,1,0); step_f(0,1,0,1);
 step_f(1,0,1,0); step_f(1,1,3,0); step_f(1,3,2,0);
 step_f(1,2,2,0); step_f(0,2,0,1);
 step_f(1,0,1,0); step_f(1,1,3,0); step_f(0,3,0,1);
 reset_all();
 coin(4,1,0); coin(2,3,0); coin(4,4,0); coin(2,4,0); coin(1,0,1);
 reset_all(); coin(4,1,0); coin(2,3,0); coin(1,3,0);
 reset_all(); coin(2,2,0); coin(2,4,0); coin(4,4,0); coin(1,0,1);
 reset_all(); coin(1,0,0); coin(4,1,0); coin(1,1,0); coin(4,2,0);
 coin(1,2,0); coin(4,3,0); coin(4,4,0); coin(1,0,1);
 reset_all();
 for(i=0;i<16;i=i+1) begin
  @(negedge clk); en=1;
  @(posedge clk); #1;
  ck(up===((i+1)%4),"2-bit modulo-4");
  ck(ud===seq[i],"3-bit triangular sequence");
 end
 @(negedge clk); en=0;
 repeat(3) begin @(posedge clk); #1; ck(up===0 && ud===2,"enable hold"); end
 reset_all();
 $display("CORE_PASS checks=%0d",checks);
 #10; $finish;
end
endmodule
