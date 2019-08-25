`timescale 1ns/1ns
module SCP_TB;

	reg Clock;
	reg Reset; 
	wire [3:0]FlagReg;
	wire [31:0]Result_Out;
	
	SCP DUT(.Clock(Clock), .Reset(Reset), .FlagReg(FlagReg), .Result_Out(Result_Out));
	
	initial begin 
		Clock = 0;
		forever begin
		#5 Clock = ~Clock;
		end
	end	
	
	initial begin	
	Reset = 1;
	#10;
	Reset = 0;
	end 
	
endmodule
