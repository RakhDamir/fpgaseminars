`timescale 1ns / 1ps
module usb_transceiver_tb;

	// Inputs
	reg rst;
	reg clk;
	reg rx_ready;
	reg tx_ready;

	// Outputs
	wire rd_en;
	wire wr_en;

	// Bidirs
	wire [7:0] databus;
	reg  [7:0] usb_data;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	usb_transceiver uut (
		.rst(rst), 
		.clk(clk), 
		.rx_ready(rx_ready),
		.tx_ready(tx_ready), 
		.rd_en(rd_en),
		.wr_en(wr_en), 
		.databus(databus)
	);

	assign databus = (tx_ready)? usb_data : 8'bZZZZ_ZZZZ;

	initial begin
		// Initialize Inputs
		rst = 0;  clk = 0; 	rx_ready = 1;  tx_ready = 1; #100;
        rst = 1; 						   #50;

        for( i = 0; i < 10; i = i + 1 ) begin
        	rx_ready = 0; #50;
        	while(rd_en == 1'b0)
        		#20;
        	rx_ready = 1; #10

        	tx_ready = 0; #50;
        	while(wr_en == 1'b0)
        		#20;
        	tx_ready = 1; #10

        	#100;	
        end
		// Add stimulus here

	end

	always @(posedge clk) begin
		usb_data <= i;	
	end

	always begin
		clk = ~clk; #5;
	end
    
endmodule

