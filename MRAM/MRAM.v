module MRAM #(
  parameter ADDR_WIDTH = 20
)
(
  clk,
  enable,
  write_en,
  lb_enable,
  ub_enable,
  addr,
  dqu,
  dql
);
  localparam MEM_NUM = 2**ADDR_WIDTH;

  input                 clk;
  input                 enable;
  input                 write_en;
  input                 lb_enable;
  input                 ub_enable;
  input [ADDR_WIDTH-1:0]addr;
  inout [15:7]          dqu;
  inout [ 7:0]          dql;

  mram [15:0] [MEM_NUM-1:0];


  always @(posedge clk) 
  begin
    if(enable)
    begin
      if(~write_en)
      begin
        if((~lb_enable) && (~ub_enable))
        begin
          mram [addr] [ 7:0] <= dql;
          mram [addr] [15:7] <= dqu;
        end
        if((~lb_enable) && (ub_enable))
        begin
          mram [addr] [ 7:0] <= dql;
        end
        if((lb_enable) && (~ub_enable))
        begin
          mram [addr] [15:7] <= dqu;
        end
        if((lb_enable) && (ub_enable))
        begin
        end
      end
      if(write_en)
      begin
        if((~lb_enable) && (~ub_enable))
        begin
          dql <= mram [addr] [ 7:0];
          dqu <= mram [addr] [15:7];
        end
        if((~lb_enable) && (ub_enable))
        begin
          dql <= mram [addr] [ 7:0];
          dqu <= 'hZZ;
        end
        if((lb_enable) && (~ub_enable))
        begin
          dql <= 'hZZ;
          dqu <= mram [addr] [15:7];
        end
        if((lb_enable) && (ub_enable))
        begin
          dql <= 'hZZ;
          dqu <= 'hZZ;
        end
      end
    end
    else
    begin
      dql <= 'hZZ;
      dqu <= 'hZZ;
    end
  end


endmodule