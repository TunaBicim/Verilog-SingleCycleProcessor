module IM(reset, read_addr, read_data);

	parameter Addr_W = 64; 
	parameter Data_W = 32;
	input  reset;
	input  [31:0]read_addr;
	output [Data_W-1:0]read_data;
	integer k;
	reg [Data_W-1:0] memory [Addr_W-1:0];

	assign read_data=memory[read_addr[7:2]];

	always@(posedge reset) begin 
		if (reset== 1'b1) begin 
			for (k=8; k<64; k=k+1) begin
				memory[k] = 32'b0;
			end
		end 
					  //Cond Op Funct  Rn   Rd   Src2 
		memory[0] = 32'b1110_00_101001_0000_0000_0000_0001_0110; // R0 <- R0 + 22    No move operation so use add to load 
		memory[1] = 32'b1110_00_101001_0001_0001_0000_0011_0111; // R1 <- R1 + 55
		memory[2] = 32'b1110_00_000001_0001_0010_0000_0000_0000; // R2 <- R1 & R0 = 0001 0110 = 22
		memory[3] = 32'b1110_00_010100_0000_0000_0000_0010_0010; // Compare (R0,R2)
		memory[4] = 32'b1110_01_000000_0011_0000_0000_0000_0100; // Mem[R3+4] <- R0
		memory[5] = 32'b1110_01_000001_0011_0100_0000_0000_0100; // R4 <- Mem[R3+4] 
		memory[6] = 32'b1110_00_011011_0000_0000_0000_1000_0000; // R0 <- R0 << 1
		memory[7] = 32'b1110_00_011011_0000_0010_0000_1010_0010; // R2 <- R2 >> 1 
	end 
endmodule 
