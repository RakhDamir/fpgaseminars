module usb_transceiver(
			input 			    rst,
			input				clk,
			input				rx_ready,
			input				tx_ready,
			output	reg			wr_en,
			output	reg	        rd_en,
			inout		 [7:0]	databus
			);

parameter 	RD_IDLE = 3'b000;
parameter 	RD_PRE_WAIT = 3'b001;
parameter 	RD_POST_WAIT = 3'b010;
parameter 	WR_IDLE = 3'b011;
parameter 	WR_WAIT = 3'b100;
parameter 	WR_DONE = 3'b101;

reg [2:0] 	state = RD_IDLE;
reg [3:0] 	cnt = 4'b0000;

// bidirectional bus
reg [7:0] 	data_rx = 8'b0000_0000;
reg [7:0] 	data_tx;
reg 		out_en;


assign databus = out_en ? data_tx : 8'bZZZZ_ZZZZ;
//assign data_rx = databus;


always @ (posedge clk)
	if (rst == 1'b0)  begin
		state 	<= RD_IDLE;
		cnt 	   <= 4'b0000;
		out_en 	<= 1'b0;
		wr_en 	<= 1'b1;
		rd_en		<= 1'b1;
      end
	else
		case(state)
			RD_IDLE: begin
				out_en 	<= 1'b0;
				if (rx_ready == 1'b0) begin
					state <= RD_PRE_WAIT;
					rd_en <= 1'b0;
				end
			end
			RD_PRE_WAIT: begin
				cnt <= cnt + 1'b1;
				if (cnt == 4'b0001) begin
					state   <= RD_POST_WAIT;
					data_rx <= databus; // there is error!!!
					cnt     <= 4'b0000;
				end
			end
			RD_POST_WAIT: begin
				rd_en 	<= 1'b1;
				cnt 	<= cnt + 1'b1;
				if (cnt == 4'b0001) begin
					state 	<= WR_IDLE;
					cnt   	<= 4'b0000;
					out_en 	<= 1'b0;
				end
			end
			WR_IDLE:
				if (tx_ready == 0) begin
					state 	<= WR_WAIT;
					data_tx <= 8'd34;
					out_en 	<= 1'b1;
				end
			WR_WAIT: begin 
				wr_en 	<= 1'b0;
				state 	<= WR_DONE;
			end
			WR_DONE:	begin
				wr_en  	<= 1'b1;
				out_en 	<= 1'b0;
				state 	<= RD_IDLE;
			end

			default:
				state <= RD_IDLE;	
		endcase

endmodule      
