module CRC (clk,
            res,
            data_in,
            data_valid,
            data_out,
            crc_valid);

input           clk;
input           res;
input           data_in;
input           data_valid;
output          data_out;
output          crc_valid;

wire    [31:0] Gx= 32'h82608EDB;
reg            DL [31:0] = 1'b1;
//reg    [7:0] DL [31:0] [32:0];
wire bit_buffer;

genvar i;
generate 
    for (i=0;i<31; i=i+1) begin
        if (i==0)
            always @ (posedge clk) begin
                if (res)
                    DL[i+1] <= 1'b1;
                    DL[i]   <= 1'b1;
                else begin
                    //wire1[i] = bit_buffer and Gx[i];
                    //wire2[i] = wire1[i] xor DL[i];
                    //DL[i+1] <=    wire2[i];
                    DL[i+1] <=  (bit_buffer 
                                and Gx[i]) 
                                xor DL[i];
                    DL[i] < = bit_buffer;
                end
            end
        else 
            always @ (posedge clk) begin
                if (res)
                    DL[i+1] <= 1'b1;
                else begin
                    DL[i+1] <=  (bit_buffer 
                                and Gx[i]) 
                                xor DL[i];
                end 
            end
        end
    end
endgenerate

// always @(posedge clk) begin
//  if (rst) begin
//      DL[31:0]=32'hFFFFFFFF;      
//  end
//  else if () begin
        
//  end
// end

endmodule
