module buttoncontrol (
							  input clock,
							  input reset,
							  input button,
							  output reg valid_vote
							  );
							  
	reg [30:0] counter;
	
	always @(posedge clock)
	begin 
		 if (reset)
				counter <= 0;
		 else
		 begin
		     if (button ==0 & counter < 11)
			     counter <= counter + 1 ;
				  
			  else if (!button)
			     counter <=0;
				  
		end 
	end
	
	always @(posedge clock)
	begin
		 if (reset)
		     valid_vote <= 1'b0;
			  
		 else
		 begin 
		     if (counter==10)
			    valid_vote <= 1'b1;
			  else
			     valid_vote <= 1'b0;
				  
		 end
	end
	
endmodule 

module votelogger (
							input clock,
							input reset,
							input mode,
							input cand1_valid_vote,
							input cand2_valid_vote,
							input cand3_valid_vote,
							input cand4_valid_vote,
							output reg [7:0] cand1_vote_received,
							output reg [7:0] cand2_vote_received,
							output reg [7:0] cand3_vote_received,
							output reg [7:0] cand4_vote_received
							);
							
	always@(posedge clock)
	 begin 
	     if (reset)
		  begin 
				cand1_vote_received <=0;
				cand2_vote_received <=0;
				cand3_vote_received <=0;
				cand4_vote_received <=0;
		  end
		  
		  else
		   begin
				if (cand1_valid_vote & mode ==0)
					cand1_vote_received = cand1_vote_received +1;
				else if (cand2_valid_vote & mode ==0)
					cand2_vote_received = cand2_vote_received +1;
				else if (cand3_valid_vote & mode ==0)
					cand3_vote_received = cand3_vote_received +1;
				else if (cand4_valid_vote & mode ==0)
					cand4_vote_received = cand4_vote_received +1;
			end
	 end
	 
endmodule

module modecontrol (
						  input clock,
						  input reset,
						  input mode,
						  input valid_vote_casted,
						  input [7:0] cand1_vote,
						  input [7:0] cand2_vote,
						  input [7:0] cand3_vote,
						  input [7:0] cand4_vote,
						  input cand1_button_press,
						  input cand2_button_press,
						  input cand3_button_press,
						  input cand4_button_press,
						  output reg [7:0] leds
						  );
						  
						  reg [30:0] counter;
						  
						  
						  
	always @(posedge clock)
	begin 
		if (reset)
		  counter <=0;
		 else if (valid_vote_casted)
			counter<= counter +1;
		 else if ( counter !=0 & counter <10)
			 counter <= counter + 1;
		  else 
			 counter <=0;
	 end
	 
	always @(posedge clock)
	begin 
	    if (reset)
		   leds <=8'h00;
		 else 
	     begin 
		    if (mode==0 & counter>0) 
			  leds <=8'hFF;
			 else if (mode==0 )
			  leds <=8'b00;
			 else if  (mode ==1)
			 begin 
			      if (cand1_button_press)
				      leds <= cand1_vote;
			      else if (cand2_button_press)
				      leds <= cand2_vote;
			      else if (cand3_button_press)
				      leds <= cand3_vote;
			      else if (cand4_button_press)
				      leds <= cand4_vote;
			 end
		 end
	end
endmodule 

module VOTING_MACHINE(
							input clock,
							input reset,
							input mode,
							input button1,
							input button2,
							input button3,
							input button4,
							output [7:0] leds
							);
							
							wire valid_vote1;
							wire valid_vote2;
							wire valid_vote3;
							wire valid_vote4;
							wire [7:0] cand1_vote_received;
							wire [7:0] cand2_vote_received;
							wire [7:0] cand3_vote_received;
							wire [7:0] cand4_vote_received;
							
							wire anyvalid_vote;
							
	assign anyvalid_vote = valid_vote1|valid_vote2|valid_vote3|valid_vote4;
	
	buttoncontrol BC1 (
	.clock(clock),
	.reset(reset), 
	.button(button1),
	.valid_vote(valid_vote1)
	);
	 
	buttoncontrol BC2 (
	.clock(clock),
	.reset(reset),
	.button(button2),
	.valid_vote(valid_vote2)
	);
	
	buttoncontrol BC3 (
	.clock(clock),
	.reset(reset),
	.button(button3),
	.valid_vote(valid_vote3)
	);

	buttoncontrol BC4 (
	.clock(clock),
	.reset(reset),
	.button(button4),
	.valid_vote(valid_vote4)
	);
	
 
   votelogger VT1 (
	.clock(clock),
	.reset(reset),
	.mode (mode),
	.cand1_valid_vote(valid_vote1),
	.cand2_valid_vote(valid_vote2),
	.cand3_valid_vote(valid_vote3),
	.cand4_valid_vote(valid_vote4),
	.cand1_vote_received(cand1_vote_received),
	.cand2_vote_received(cand2_vote_received),
	.cand3_vote_received(cand3_vote_received),
	.cand4_vote_received(cand4_vote_received)
	);
	
modecontrol MC (
					  .clock(clock),
					  .reset(reset),
					  .mode(mode),
					  .valid_vote_casted(anyvalid_vote),
					  .cand1_vote(cand1_vote_received),
					  .cand2_vote(cand2_vote_received),
					  .cand3_vote(cand3_vote_received),
					  .cand4_vote(cand4_vote_received),
					  .cand1_button_press(valid_vote1),
					  .cand2_button_press(valid_vote2),
					  .cand3_button_press(valid_vote3),
					  .cand4_button_press(valid_vote4),
					  .leds(leds)
					  );
endmodule
					  