`timescale 1 ns/1 ns

module Debouncer
  #(parameter WIDTH = 4)
(
input clk,
input button,
output signal
);

  reg [WIDTH-1:0] ctr_d, ctr_q;
  reg [1:0] sync_d, sync_q;
 
   always @(posedge clk) begin
    ctr_q <= ctr_d;
    sync_q <= sync_d;
  end
 
  always @(*) begin
    sync_d[0] = button;
    sync_d[1] = sync_q[0];
    ctr_d = ctr_q + 1'b1;
 
    if(ctr_q == {WIDTH{1'b1}}) ctr_d = ctr_q;
      
    if(!sync_q[1]) ctr_d = 'd0;
  end
  
  assign signal = ctr_q == {WIDTH{1'b1}};
  
endmodule