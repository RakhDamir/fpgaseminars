`timescale 1ns / 1ps

module pipeline(
      clk,
      rst,
      data_in,
      data_out1,
      data_out2
    );

parameter	DATA_WIDTH	= 16,
				FFT_LENGTH	= 64,
				CP_LENGTH	= 16;

// input and output
input 							clk;
input								rst;
input		[DATA_WIDTH-1:0]	data_in;
output	[DATA_WIDTH-1:0]	data_out1;
output	[DATA_WIDTH-1:0]	data_out2;

// variables
reg [DATA_WIDTH-1:0] delay_fft 	[FFT_LENGTH-1:0];
reg [DATA_WIDTH-1:0] delay_cp 	[CP_LENGTH-1:0];
// code for programm

// generate delayline for symbol (FFT)
genvar i;
generate 
	for (i=0; i<FFT_LENGTH; i=i+1)
		if (i==0)
			always @(posedge clk) 	delay_fft[0] 	<= data_in;
		else
			always @(posedge clk) 	delay_fft[i] <= delay_fft[i-1];
endgenerate

// generate delayline for cycle prefix (CP)
genvar j;
generate 
	for (j=0; j<CP_LENGTH; j=j+1)
		if (j==0)
			always @(posedge clk) 	delay_cp[0] 	<= delay_fft[FFT_LENGTH-1];
		else
			always @(posedge clk) 	delay_cp[j] 	<= delay_cp[j-1];
endgenerate

// connects between ports and delaylines

assign data_out1 = delay_fft[FFT_LENGTH-1];
assign data_out2 = delay_cp[CP_LENGTH-1];

endmodule
