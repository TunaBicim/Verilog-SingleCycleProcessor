module SCP(Clock,Reset,FlagReg,Result_Out);

	input Clock,Reset;
	output [3:0] FlagReg;
	output [31:0] Result_Out;
	wire  Clock;
	wire  [3:0] Cond;
	wire  [1:0] Op;
	wire  [5:0] Funct;
	wire  [3:0] Rd;
	wire  [3:0] Flags;
	wire  MemtoReg,PCSrc, ALUSrc, MemWrite;  
	wire  ImmSrc, RegWrite, Shift,RegSrc;
	wire [2:0] ALUControl;
	
	Datapath m_Datapath(.Clock(Clock), .Reset(Reset), .PCSrc(PCSrc), .MemtoReg(MemtoReg), .MemWrite(MemWrite), 
				.ALUSrc(ALUSrc), .ALUControl(ALUControl), .ImmSrc(ImmSrc), .RegWrite(RegWrite), .Shift(Shift), 
				.RegSrc(RegSrc), .Cond(Cond), .Op(Op), .Funct(Funct), .Rd(Rd), .Flags(Flags), .Result_Out(Result_Out));

	Controller m_Controller (.Clock(Clock), .Cond(Cond), .Op(Op), .Funct(Funct), .Rd(Rd), .Flags(Flags),
				  .PCSrc(PCSrc), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .Shift(Shift), 
				  .RegSrc(RegSrc), .ImmSrc(ImmSrc), .RegWrite(RegWrite),.ALUControl(ALUControl), .FlagReg(FlagReg));
				  
endmodule	  
