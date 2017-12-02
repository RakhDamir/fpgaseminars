`timescale 1ns / 1ps
module integrator( 
         clk, 
         rst, 
         data_in, 
         data_out
    );
    
parameter	DATA_WIDTH    = 14, // разрядность входной шины данных
			   INTEGR_LENGTH = 16; // длинна интегрирования отсчётов
            


// INPUTS and OUTPUTS            
input                      clk;
input                      rst;
input    [DATA_WIDTH-1:0]  data_in;
output   [DATA_WIDTH-1:0]  data_out;

// VARIABLES
reg [DATA_WIDTH-1:0] delay [INTEGR_LENGTH-1:0];
reg [DATA_WIDTH-1:0] acc;
reg [DATA_WIDTH-1:0] diff;

// Delay Line
genvar i;
generate
	for (i=0; i<INTEGR_LENGTH-1; i=i+1) begin
		always @(posedge clk) begin
			delay[i+1] <= delay[i];
		end
	end
endgenerate

// differentiation and accumulation
always @(posedge clk) begin
	delay[0] 	<= data_in;
	diff 		<= data_in - delay[INTEGR_LENGTH-1]; 
	acc 		<= acc + diff;
end

// connect output 
assign data_out = acc;

endmodule
