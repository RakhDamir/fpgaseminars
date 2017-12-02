`timescale 1ns / 1ps

module RX_correlator(
      clk,
      rst,
      data_in,
      data_out,
      corr
    );


// list of parameters
parameter   DATA_WIDTH     = 48,
            CP_LENGTH      = 64,
            FFT_LENGTH     = 256;


// input and output ports
input                         clk;
input                         rst;
input    [DATA_WIDTH-1:0]     data_in;
output   [DATA_WIDTH-1:0]     data_out;
output   [2*DATA_WIDTH-1:0]   corr;


// variables
reg   [DATA_WIDTH-1:0] r0;
wire  [DATA_WIDTH-1:0] rN;
reg   [2*DATA_WIDTH-1:0] rMult;


// multiplier
always @(posedge clk) begin
   r0    <= data_in;
   rMult <= $signed(r0) * $signed(rN);
end


// Instantiate the pipeline
pipeline #(
   .DATA_WIDTH(DATA_WIDTH),
   .FFT_LENGTH(FFT_LENGTH),
   .CP_LENGTH(CP_LENGTH)
   )
pipeline_inst1 (
   .clk(clk), 
   .rst(rst), 
   .data_in(r0), 
   .data_out1(rN), 
   .data_out2()
   );


// Instantiate the integrator
integrator #(
   .DATA_WIDTH(2*DATA_WIDTH),
   .INTEGR_LENGTH(CP_LENGTH)
   )
integrator_inst1 (
   .clk(clk), 
   .rst(rst), 
   .data_in(rMult), 
   .data_out(corr)
   );


endmodule
