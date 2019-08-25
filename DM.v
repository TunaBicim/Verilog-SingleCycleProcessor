module DM(clock, reset, write_enable, write_data, addr, read_data);
  
	parameter Addr_W = 64; 
	parameter Data_W = 32;
	input  clock;
	input  reset;
	input  write_enable;
	input  [31:0]addr;
	input  [Data_W-1:0]write_data;
	output [Data_W-1:0]read_data;
	integer k;
	reg [Data_W-1:0] memory [Addr_W-1:0];
	
	assign read_data=memory[addr[7:2]];

	always@(posedge clock) begin 
		if (reset== 1'b1) begin 
			for (k=0; k<64; k=k+1) begin
				memory[k] = 32'b0;
			end
		end else if (write_enable==1'b1) begin
			memory[addr[7:2]] = write_data;
		end
	end 
endmodule
