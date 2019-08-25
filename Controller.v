module Controller(Clock, Cond, Op, Funct, Rd, Flags,
				  PCSrc, MemtoReg, MemWrite, ALUSrc,
				  ImmSrc, RegWrite, Shift, RegSrc,
				  ALUControl, FlagReg);
				  
	input  Clock;
	input [3:0] Cond;
	input [1:0] Op;
	input [5:0] Funct;
	input [3:0] Rd;
	input [3:0] Flags;
	output reg PCSrc, MemtoReg,ALUSrc;  
	output reg MemWrite, ImmSrc, RegWrite, Shift,RegSrc;
	output reg [2:0] ALUControl;
	output reg[3:0] FlagReg;
	reg ALUOp;
	reg [1:0]FlagW;
	reg NoWrite;
	
	//Main Decoder
	always@(Op, Funct, NoWrite,Rd) begin 
		
		PCSrc	 = (Rd == 4'hF); 
		MemtoReg = 0; 
		ALUSrc   = 0;  
		MemWrite = 0; 
		ImmSrc 	 = 0;
		RegWrite = 0;
		RegSrc	 = 0;
		ALUOp 	 = 0;
		if (Op == 2'b00) begin 
			MemtoReg = 0;
			MemWrite = 0;
			RegWrite = ~NoWrite;
			ALUOp 	 = 1;
			if (Funct[5] == 1) begin 
				ALUSrc = 1;
				ImmSrc = 0;
			end else begin 
				RegSrc = 0;
				ALUSrc = 0;
			end 
		end else if (Op == 2'b01) begin 
			MemtoReg = 1;
			RegSrc   = 1;
			ALUOp 	 = 0;
			ALUSrc   = 1;  
			ImmSrc 	 = 1;
			if (Funct[0]==1) begin 
				MemWrite = 0;
				RegWrite = 1;
			end else begin 
				MemWrite = 1;
				RegWrite = 0;
			end
		end 
	end 
	//ALU Decoder
	always@(Funct, ALUOp) begin 
		ALUControl = 3'b000;
		FlagW = 2'b00;
		if (ALUOp == 0) begin 
			ALUControl = 3'b000;
			FlagW = 2'b00;
			NoWrite = 0;
			Shift = 0;
		end else begin 
			case(Funct[4:1])
				4'h0: begin //Logical AND
					ALUControl = 3'b100;
					FlagW = Funct[0] ? 2'b10 : 2'b00;
					NoWrite = 0;
					Shift = 0;
				end 
				4'h2: begin //Subtraction
					ALUControl = 3'b001;
					FlagW = Funct[0] ? 2'b11 : 2'b00;
					NoWrite = 0;
					Shift = 0;
				end 
				4'h4: begin //Addition
					ALUControl = 3'b000;
					FlagW = Funct[0] ? 2'b11 : 2'b00;
					NoWrite = 0;
					Shift = 0;
				end 
				4'hA: begin //Compare
					ALUControl = 3'b001;
					FlagW = 2'b11;
					NoWrite = 1;
					Shift = 0;
				end 
				4'hC: begin //Logical OR
					ALUControl = 3'b101;
					FlagW = Funct[0] ? 2'b10 : 2'b00;
					NoWrite = 0;
					Shift = 0;
				end
				4'hD: begin 
					Shift = 1;
					NoWrite = 0;
				end
				default: begin
					ALUControl = 3'b000;
					FlagW = 2'b00;
					Shift = 0;
					NoWrite = 0;
				end 
			endcase 
		end 
	end 
	
	always@(posedge Clock) begin 
		if (FlagW[0] == 1'b1) begin 
			FlagReg[1:0] <= Flags[1:0];
		end 
		if (FlagW[1] == 1'b1) begin 
			FlagReg[3:2] <= Flags[3:2];
		end 
	end 
	
endmodule 
	