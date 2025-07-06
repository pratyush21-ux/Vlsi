module Traffic_light_con(
  input wire clk,
  input wire rst,
  output reg [2:0] ns_light,
  output reg [2:0] ew_light
);
parameter s0=3'b000,//ns green
         s1=3'b001,//ns yellow
         s2=3'b010,//ew green
         s3=3'b011,//ew yellow
         s4=3'b100;// red
reg [2:0]current_state,next_state;
reg [2:0]from_state;
integer timer;
always@(posedge clk or posedge rst)
begin 
  if(rst)
  begin 
    current_state<=s0;
    timer<=0;
  end
  else
  begin
    current_state<=next_state;
    timer<=(current_state!=next_state)?0:timer+1;
  end
end
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    from_state<=s0;
  end
  else if(next_state==s4&&current_state!=s4)
  begin
    from_state<=current_state;
  end
end
always@(*)
begin
  case(current_state)
  s0:next_state=(timer>=10)?s1:s0;
  s1:next_state=(timer>=3)?s4:s1;
  s2:next_state=(timer>=10)?s3:s2;
  s3:next_state=(timer>=3)?s4:s3;
  s4:next_state=(timer>=10)?((from_state==s1)?s2:s0):s4;
  default:next_state=s0;
  endcase
end
always@(*)
begin
  case(current_state)
  s0:
  begin
    ns_light=3'b001;
    ew_light=3'b100;
  end
  s1:
  begin
    ns_light=3'b010;
    ew_light=3'b100;
  end
  s2:
  begin 
    ns_light=3'b100;
    ew_light=3'b001;
  end
   s3: 
   begin
    ns_light = 3'b100;
    ew_light = 3'b010; 
    end
    s4: 
    begin
      ns_light = 3'b100; 
      ew_light = 3'b100; 
    end
    default: 
    begin
      ns_light = 3'b100;
      ew_light = 3'b100;
    end
  endcase
end 
endmodule
  