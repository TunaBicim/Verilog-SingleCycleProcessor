module SignExtender (In, Out, ExtType);
	
	input [11:0] In;
	input ExtType;
	output [31:0] Out;
	
	wire [31:0] Ext12;
	wire [31:0] Ext8;
	
	assign Ext12 = {{20{1'b0}},In[11:0]};
	assign Ext8 =  {{24{1'b0}},In[7:0]};
	assign Out = (ExtType==1'b1) ? Ext12 : Ext8;  

endmodule 
