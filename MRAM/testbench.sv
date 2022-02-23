  `timescale 1ns/1ps

  module testbench;

  logic  clk,
  logic  enable,
  logic  write_en,
  logic  lb_enable,
  logic  ub_enable,
  logic  addr,
  logic  dqu,
  logic  dql

  class in_transaction;
  rand  bit           enable;
  rand  bit           write_en;
  rand  bit           lb_enable;
  rand  bit           ub_enable;
  rand  bit [19:0]    addr;
  rand  bit [ 7:0]    dqu;
  rand  bit [ 7:0]    dql;


  // constraint write {
  //                   enable    = 1;
  //                   write_en  = 0;
  // }
  // constraint read {
  //                   enable    = 1;
  //                   write_en  = 1;
  // }
  function new();
    $display("In Transaction has been created");
  endfunction   

  endclass



  class out_transaction;

  rand  bit       read_ready;
  function new();
    $display("Out Transaction has been created");
  endfunction  

  endclass

  MRAM i_mram(
    .clk          (clk)
    .enable       (enable),
    .write_en     (write_en),
    .lb_enable    (lb_enable),
    .ub_enable    (ub_enable),
    .addr         (addr),
    .dqu          (dqu),
    .dql          (dql)
    );


  // Driver
  class driver;
  in_transaction tr_in;
  bit [15:0] data_ref;
  bit [15:0] golden_data[$];

  function new ();
    $display("Driver has been created");
  endfunction

  task mram_write;
    in_transaction tr_in;
    tr_in.randomize() with{enable == 1; write_en == 0;}
    @(negedge clk)
    begin
      enable    = tr_in.enable;
      write_en  = tr_in.write_en;
      lb_enable = tr_in.lb_enable;
      ub_enable = tr_in.ub_enable;
      addr      = tr_in.addr;
      dqu       = tr_in.dqu;
      dql       = tr_in.dql;
    end
    data_ref = {tr_in.dqu & (~tr_in.ub_enable), tr_in.dql & (~tr_in.lb_enable)};
    golden_data.push_back(data_ref);  
  endtask

  task mram_read;
    in_transaction tr_in;
    tr_in.randomize() with{enable == 1; write_en == 1;}
    @(negedge clk)
    beginl
      enable    = tr_in.enable;
      write_en  = tr_in.write_en;
      lb_enable = tr_in.lb_enable;
      ub_enable = tr_in.ub_enable;
      addr      = tr_in.addr;
      dqu       = tr_in.dqu;
      dql       = tr_in.dql;
    end
    data_ref = {tr_in.dqu & (~tr_in.ub_enable), tr_in.dql & (~tr_in.lb_enable)};
    golden_data.push_back(data_ref);  
  endtask

  endclass
    in_transaction tr_in;
    bit [15:0] data_in;
    bit [15:0] golden_data[$];
    always_ff @(negedge clk_i) 
    begin
      tr_in.randomize;

      io_writePorts_valid         = tr_in.data_valid;
      data_in                     = tr_in.data_in;
      if(tr_in.data_valid && start)
      begin
        io_writePorts_bits_validNum = tr_in.valid_num;
        for(int i = 0; i < 25; i++)
        begin
          if(i < tr_in.valid_num)
          begin
            data_in[i] = tr_in.data_in[i];
          end
          else
          begin
            data_in[i] = 0;
          end
        end
      end
      else
      begin
        for (int k = 0; k < 25; k++) 
        begin
          io_writePorts_bits_validNum = 0;
          data_in[k] = 0;
        end
      end

      if(io_writePorts_ready)
      begin
        io_writePorts_bits_data_0   = data_in[0];
        io_writePorts_bits_data_1   = data_in[1];
        io_writePorts_bits_data_2   = data_in[2];
        io_writePorts_bits_data_3   = data_in[3];
        io_writePorts_bits_data_4   = data_in[4];
        io_writePorts_bits_data_5   = data_in[5];
        io_writePorts_bits_data_6   = data_in[6];
        io_writePorts_bits_data_7   = data_in[7];
        io_writePorts_bits_data_8   = data_in[8];
        io_writePorts_bits_data_9   = data_in[9];
        io_writePorts_bits_data_10  = data_in[10];
        io_writePorts_bits_data_11  = data_in[11];
        io_writePorts_bits_data_12  = data_in[12];
        io_writePorts_bits_data_13  = data_in[13];
        io_writePorts_bits_data_14  = data_in[14];
        io_writePorts_bits_data_15  = data_in[15];
        io_writePorts_bits_data_16  = data_in[16];
        io_writePorts_bits_data_17  = data_in[17];
        io_writePorts_bits_data_18  = data_in[18];
        io_writePorts_bits_data_19  = data_in[19];
        io_writePorts_bits_data_20  = data_in[20];
        io_writePorts_bits_data_21  = data_in[21];
        io_writePorts_bits_data_22  = data_in[22];
        io_writePorts_bits_data_23  = data_in[23];
        io_writePorts_bits_data_24  = data_in[24];
      end
    end

    always_ff @(posedge clk_i) 
    begin
      if(tr_in.data_valid && start && io_writePorts_ready)
      begin
        for(int i = 0; i < io_writePorts_bits_validNum; i++)
        begin
          golden_data.push_back(tr_in.data_in[i]);
        end   
      end       
    end

  //Monitor
    out_transaction tr_out;
    bit [7:0] data_out[$];
    bit       out_data_valid;
    bit [7:0] data_0;
    bit [7:0] data_1;
    bit [7:0] data_2;
    bit [7:0] data_3;

    always_ff @(negedge clk_i) 
    begin
      tr_out.randomize;
      io_readPort_ready <= tr_out.read_ready;
    end

    always_ff @(posedge clk_i) 
    begin
      out_data_valid = io_readPort_valid & start;
      if(io_readPort_ready && out_data_valid)
      begin
          data_0 = io_readPort_bits_0;
          data_1 = io_readPort_bits_1;
          data_2 = io_readPort_bits_2;
          data_3 = io_readPort_bits_3;
          data_out.push_back(data_0); 
          data_out.push_back(data_1); 
          data_out.push_back(data_2); 
          data_out.push_back(data_3); 
           // foreach(data_out[m]) 
           // begin
           //   $display("data_out = %d",data_out[m]);  
           // end
      end
    end


    always #5 clk_i = ~clk_i;

    initial
    begin
      tr_in  = new();
      tr_out = new();
      clk_i = 0;
      start = 0;
      #10;
      rst_ni = 0;
      #10;
      rst_ni = 1;
      #10;
      rst_ni = 0; 
      #5;
      start = 1;
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