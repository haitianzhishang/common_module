module Ping_Pong_buffer  #(
  parameter VALID_NUM = 2'b11 
)
(
  Clk,
  Rst,
  Wr_valid,
  Wr_ready,
  Wr_data,
  Rd_valid,
  Rd_ready,
  Rd_data
  );
input                   Clk;
input                   Rst;
output                  Wr_ready;
input                   Wr_valid;
input  [31:0]           Wr_data;
output                  Rd_valid;
input                   Rd_ready;
output [9 :0]           Rd_data;



reg  [ 1:0]             Wr_valid_num;
reg  [ 9:0]             Wr_valid_data[2:0];   

reg  [ 1:0]             Buffer_pt_wr;
reg  [ 1:0]             Buffer_pt_rd;
reg  [ 1:0]             Wr_pt;
reg  [ 1:0]             Rd_pt;
reg  [ 9:0]             Buffer_1[2:0];
reg  [ 9:0]             Buffer_2[2:0];

always @(Wr_data, Wr_valid) 
begin
  if(Wr_valid)
  begin
    Wr_valid_num = Wr_data[1:0];
    case(Wr_valid_num)
    2'b00 :
          begin
            Wr_valid_data[0] = 10'b0;
            Wr_valid_data[1] = 10'b0;
            Wr_valid_data[2] = 10'b0;
          end
    2'b01 :
         begin
           Wr_valid_data[0] = Wr_data[11: 2];
           Wr_valid_data[1] = 10'b0;
           Wr_valid_data[2] = 10'b0;
         end
    2'b10 :
         begin
           Wr_valid_data[0] = Wr_data[11: 2];
           Wr_valid_data[1] = Wr_data[21:12];
           Wr_valid_data[2] = 10'b0;
         end
    2'b11 :
         begin
           Wr_valid_data[0] = Wr_data[11: 2];
           Wr_valid_data[1] = Wr_data[21:12];
           Wr_valid_data[2] = Wr_data[31:22];
         end
    endcase               
  end
  else 
  begin
    Wr_valid_num      = 2'b0;
    Wr_valid_data[0]  = 10'b0;
    Wr_valid_data[1]  = 10'b0;
    Wr_valid_data[2]  = 10'b0;
  end
end

assign Wr_ready = (Buffer_pt_wr[1] == Buffer_pt_rd[1]);
assign Rd_valid = ((Buffer_pt_wr[1] == Buffer_pt_rd[1]) & (Buffer_pt_wr[0] & ~Buffer_pt_rd[0])) || (Buffer_pt_wr[1] != Buffer_pt_rd[1]);
assign Rd_data  =  Buffer_pt_rd[0] ? Buffer_2[Rd_pt] : Buffer_1[Rd_pt];

always @(posedge Clk or posedge Rst) 
begin
  if (Rst)
  begin
    for(integer i=0; i<3; i=i+1)
    begin
      Buffer_1[i] <= 10'b0;
      Buffer_2[i] <= 10'b0;
    end
    Buffer_pt_wr    <= 2'b0;
    Buffer_pt_rd    <= 2'b0;
    Wr_pt           <= 2'b0;
    Rd_pt           <= 2'b0;
  end
  else
  begin
    if(Wr_valid && Wr_ready && Wr_valid_num)
    begin
      Buffer_pt_wr                            <= Buffer_pt_wr + 1'b1;
      Wr_pt                                   <= Wr_valid_num;
      if(~Buffer_pt_wr[0])
      begin
        Buffer_1[0]     <= Wr_valid_data[0];
        Buffer_1[1]     <= Wr_valid_data[1];
        Buffer_1[2]     <= Wr_valid_data[2];
      end
      else 
      begin
        Buffer_2[0]     <= Wr_valid_data[0];
        Buffer_2[1]     <= Wr_valid_data[1];
        Buffer_2[2]     <= Wr_valid_data[2];
      end
    end
    else 
    begin
    end

    if(Rd_valid && Rd_ready)
    begin
      Rd_pt             <= Rd_pt + 1'b1;
      if((Rd_pt + 1) == VALID_NUM)
      begin
        Rd_pt           <= 2'b0;
        Buffer_pt_rd    <= Buffer_pt_rd + 1'b1;
      end
    end
  end
end


endmodule
