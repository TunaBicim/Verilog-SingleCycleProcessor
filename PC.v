module PC(clock, reset, PC_in, PC_out);
	
	parameter Addr_W = 32;
	input clock, reset;
	input [Addr_W-1:0] PC_in;
	output reg [Addr_W-1:0] PC_out;
	
	always @ (posedge clock) begin
		if(reset==1'b1)
			PC_out<=0;
		else
			PC_out<=PC_in;
	end
endmodule
