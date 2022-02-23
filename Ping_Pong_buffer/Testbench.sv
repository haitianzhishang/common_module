module Testbench;

  class In_transaction;
    rand bit           Wr_valid;
    rand bit [31:0]    Wr_data;
    constraint c {
                  Wr_valid == 1;
                  Wr_data[1:0] == 3;
    }
  endclass 

  class Out_transaction;
    rand bit           Rd_ready;
    constraint b {
                  Rd_ready == 1;
      
    }
  endclass

  bit                    start;
  logic                  Clk;
  logic                  Rst;
  logic                  Wr_ready;
  logic                  Wr_valid;
  logic [31:0]           Wr_data;
  logic                  Rd_valid;
  logic                  Rd_ready;
  logic [9:0]            Rd_data;

  Ping_Pong_buffer #(
    .VALID_NUM(2'b11)
    ) U_Ping_Pong_buffer
  (
  .Clk                   (Clk),
  .Rst                   (Rst),
  .Wr_ready              (Wr_ready),
  .Wr_valid              (Wr_valid),
  .Wr_data               (Wr_data),
  .Rd_valid              (Rd_valid),
  .Rd_ready              (Rd_ready),
  .Rd_data               (Rd_data)
    );

  // Driver
  In_transaction tr_in;
  bit [9:0] golden_data[$];

  always_ff @(negedge Clk) 
  begin
    tr_in.randomize;
    Wr_valid = tr_in.Wr_valid;
    Wr_data  = tr_in.Wr_data;
    if(tr_in.Wr_valid && Wr_ready && start)
    begin
      if(tr_in.Wr_data[1:0] == 2'b01)
      begin
        golden_data.push_back(tr_in.Wr_data[11: 2]);
      end
      if(tr_in.Wr_data[1:0] == 2'b10)
      begin
        golden_data.push_back(tr_in.Wr_data[11: 2]);
        golden_data.push_back(tr_in.Wr_data[21:12]);
      end
      if(tr_in.Wr_data[1:0] == 2'b11)
      begin
        golden_data.push_back(tr_in.Wr_data[11: 2]);
        golden_data.push_back(tr_in.Wr_data[21:12]);
        golden_data.push_back(tr_in.Wr_data[31:22]);
      end
    end
  end

  // Monitor
  Out_transaction   tr_out;
  bit [9:0]         data;
  bit [9:0]         data_out[$];
  bit               out_data_valid;

  always_ff @(negedge Clk) 
  begin
    tr_out.randomize;
    Rd_ready = tr_out.Rd_ready;
  end

  always_ff @(posedge Clk) 
  begin
    out_data_valid  = Rd_valid & start;
    if(Rd_ready && out_data_valid)
    begin
        data        = Rd_data;
        data_out.push_back(data); 
    end
  end


  always #5 Clk = ~Clk;

    initial
    begin
      tr_in  = new();
      tr_out = new();
      Clk = 0;
      start = 0;
      #10;
      Rst = 0;
      #10;
      Rst = 1;
      #5;
      start = 1;
            $display("Simulation starts");

      #5;
      Rst = 0; 
      #100000;
      // foreach(golden_data[l]) 
      // begin
      //   if(golden_data[l] == data_out[l])
      //   begin
      //     $display("Golden_data = %d, Real_data = %d", golden_data[l], data_out[l]);
      //     $display("Date is Right");
      //   end
      //   else
      //   begin
      //     $display("Golden_data = %d, Real_data = %d", golden_data[l], data_out[l]);
      //     $display("Data is Wrong");
      //   end  
      // end

      for (int i = 0; i < $size(golden_data); i++) 
      begin
        if(golden_data[i] == data_out[i])
        begin
          $display("Golden_data = %d, Real_data = %d", golden_data[i], data_out[i]);
          $display("Date is Right");
        end
        else
        begin
          $display("Golden_data = %d, Real_data = %d", golden_data[i], data_out[i]);
          $display("Data is Wrong");
        end  
      end
      $finish;
    end

endmodule