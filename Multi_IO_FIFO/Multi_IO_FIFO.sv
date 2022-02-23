module Multi_IO_FIFO #(
  parameter FIFO_ADDR_DEPTH = 7,
  parameter DATA_WIDTH      = 8
  )
 (
  input  logic        clk_i,    
  input  logic        rst_ni,
  output logic        io_writePorts_ready,
  input  logic        io_writePorts_valid,
  input  logic  [7:0] io_writePorts_bits_data_0,
  input  logic  [7:0] io_writePorts_bits_data_1,
  input  logic  [7:0] io_writePorts_bits_data_2,
  input  logic  [7:0] io_writePorts_bits_data_3,
  input  logic  [7:0] io_writePorts_bits_data_4,
  input  logic  [7:0] io_writePorts_bits_data_5,
  input  logic  [7:0] io_writePorts_bits_data_6,
  input  logic  [7:0] io_writePorts_bits_data_7,
  input  logic  [7:0] io_writePorts_bits_data_8,
  input  logic  [7:0] io_writePorts_bits_data_9,
  input  logic  [7:0] io_writePorts_bits_data_10,
  input  logic  [7:0] io_writePorts_bits_data_11,
  input  logic  [7:0] io_writePorts_bits_data_12,
  input  logic  [7:0] io_writePorts_bits_data_13,
  input  logic  [7:0] io_writePorts_bits_data_14,
  input  logic  [7:0] io_writePorts_bits_data_15,
  input  logic  [7:0] io_writePorts_bits_data_16,
  input  logic  [7:0] io_writePorts_bits_data_17,
  input  logic  [7:0] io_writePorts_bits_data_18,
  input  logic  [7:0] io_writePorts_bits_data_19,
  input  logic  [7:0] io_writePorts_bits_data_20,
  input  logic  [7:0] io_writePorts_bits_data_21,
  input  logic  [7:0] io_writePorts_bits_data_22,
  input  logic  [7:0] io_writePorts_bits_data_23,
  input  logic  [7:0] io_writePorts_bits_data_24,
  input  logic  [4:0] io_writePorts_bits_validNum,
  input  logic        io_readPort_ready,
  output logic        io_readPort_valid,
  output logic  [7:0] io_readPort_bits_0,
  output logic  [7:0] io_readPort_bits_1,
  output logic  [7:0] io_readPort_bits_2,
  output logic  [7:0] io_readPort_bits_3
);

localparam FIFO_DEPTH = 2**FIFO_ADDR_DEPTH;

logic [FIFO_DEPTH-1:0] [DATA_WIDTH-1:0]           regfile;
logic [FIFO_ADDR_DEPTH:0]                         write_addr;
logic                                             carry_wr;
logic [FIFO_ADDR_DEPTH:0]                         read_addr;
logic                                             carry_rd;

logic                                             write_en;
logic                                             read_en;

logic                                             fifo_full;
logic [FIFO_ADDR_DEPTH:0]                         write_full;
logic                                             carry_full;
logic                                             fifo_empty;
logic [FIFO_ADDR_DEPTH:0]                         read_empty;
logic                                             carry_empty;

logic [6:0]                                       write_addr_1;
logic [6:0]                                       write_addr_2;
logic [6:0]                                       write_addr_3;
logic [6:0]                                       write_addr_4;
logic [6:0]                                       write_addr_5;
logic [6:0]                                       write_addr_6;
logic [6:0]                                       write_addr_7;
logic [6:0]                                       write_addr_8;
logic [6:0]                                       write_addr_9;
logic [6:0]                                       write_addr_10;
logic [6:0]                                       write_addr_11;
logic [6:0]                                       write_addr_12;
logic [6:0]                                       write_addr_13;
logic [6:0]                                       write_addr_14;
logic [6:0]                                       write_addr_15;
logic [6:0]                                       write_addr_16;
logic [6:0]                                       write_addr_17;
logic [6:0]                                       write_addr_18;
logic [6:0]                                       write_addr_19;
logic [6:0]                                       write_addr_20;
logic [6:0]                                       write_addr_21;
logic [6:0]                                       write_addr_22;
logic [6:0]                                       write_addr_23;
logic [6:0]                                       write_addr_24;

logic [6:0]                                       read_addr_1;
logic [6:0]                                       read_addr_2;
logic [6:0]                                       read_addr_3;


assign write_addr_1  = write_addr + 5'b00001;
assign write_addr_2  = write_addr + 5'b00010;
assign write_addr_3  = write_addr + 5'b00011;
assign write_addr_4  = write_addr + 5'b00100;
assign write_addr_5  = write_addr + 5'b00101;
assign write_addr_6  = write_addr + 5'b00110;
assign write_addr_7  = write_addr + 5'b00111;
assign write_addr_8  = write_addr + 5'b01000;
assign write_addr_9  = write_addr + 5'b01001;
assign write_addr_10 = write_addr + 5'b01010;
assign write_addr_11 = write_addr + 5'b01011;
assign write_addr_12 = write_addr + 5'b01100;
assign write_addr_13 = write_addr + 5'b01101;
assign write_addr_14 = write_addr + 5'b01110;
assign write_addr_15 = write_addr + 5'b01111;
assign write_addr_16 = write_addr + 5'b10000;
assign write_addr_17 = write_addr + 5'b10001;
assign write_addr_18 = write_addr + 5'b10010;
assign write_addr_19 = write_addr + 5'b10011;
assign write_addr_20 = write_addr + 5'b10100;
assign write_addr_21 = write_addr + 5'b10101;
assign write_addr_22 = write_addr + 5'b10110;
assign write_addr_23 = write_addr + 5'b10111;
assign write_addr_24 = write_addr + 5'b11000;


// Write Ports
always_ff @(posedge clk_i or negedge rst_ni) 
begin
  if(rst_ni) 
  begin
    for(int i = 0; i < FIFO_DEPTH; i++)
    begin
      regfile[i] <= 0;
    end
  end
  else 
  begin
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 1)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 2)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 3)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 4)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 5)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 6)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 7)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 8)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 9)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 10)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;      
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 11)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 12)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 13)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 14)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 15)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 16)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 17)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 18)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 19)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 20)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
      regfile[write_addr_19]   <= io_writePorts_bits_data_19;      
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 21)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
      regfile[write_addr_19]   <= io_writePorts_bits_data_19;
      regfile[write_addr_20]   <= io_writePorts_bits_data_20;      
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 22)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
      regfile[write_addr_19]   <= io_writePorts_bits_data_19;
      regfile[write_addr_20]   <= io_writePorts_bits_data_20;  
      regfile[write_addr_21]   <= io_writePorts_bits_data_21;            
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 23)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
      regfile[write_addr_19]   <= io_writePorts_bits_data_19;
      regfile[write_addr_20]   <= io_writePorts_bits_data_20;  
      regfile[write_addr_21]   <= io_writePorts_bits_data_21;    
      regfile[write_addr_22]   <= io_writePorts_bits_data_22;                  
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 24)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
      regfile[write_addr_19]   <= io_writePorts_bits_data_19;
      regfile[write_addr_20]   <= io_writePorts_bits_data_20;  
      regfile[write_addr_21]   <= io_writePorts_bits_data_21;    
      regfile[write_addr_22]   <= io_writePorts_bits_data_22;
      regfile[write_addr_23]   <= io_writePorts_bits_data_23;                        
    end
    if(write_en && ~fifo_full && io_writePorts_bits_validNum == 25)
    begin
      regfile[write_addr[FIFO_ADDR_DEPTH-1:0]]      <= io_writePorts_bits_data_0;
      regfile[write_addr_1]    <= io_writePorts_bits_data_1;
      regfile[write_addr_2]    <= io_writePorts_bits_data_2;
      regfile[write_addr_3]    <= io_writePorts_bits_data_3;
      regfile[write_addr_4]    <= io_writePorts_bits_data_4;
      regfile[write_addr_5]    <= io_writePorts_bits_data_5;
      regfile[write_addr_6]    <= io_writePorts_bits_data_6;
      regfile[write_addr_7]    <= io_writePorts_bits_data_7;
      regfile[write_addr_8]    <= io_writePorts_bits_data_8;
      regfile[write_addr_9]    <= io_writePorts_bits_data_9;
      regfile[write_addr_10]   <= io_writePorts_bits_data_10;
      regfile[write_addr_11]   <= io_writePorts_bits_data_11;
      regfile[write_addr_12]   <= io_writePorts_bits_data_12;
      regfile[write_addr_13]   <= io_writePorts_bits_data_13;
      regfile[write_addr_14]   <= io_writePorts_bits_data_14;
      regfile[write_addr_15]   <= io_writePorts_bits_data_15;
      regfile[write_addr_16]   <= io_writePorts_bits_data_16;
      regfile[write_addr_17]   <= io_writePorts_bits_data_17;
      regfile[write_addr_18]   <= io_writePorts_bits_data_18;
      regfile[write_addr_19]   <= io_writePorts_bits_data_19;
      regfile[write_addr_20]   <= io_writePorts_bits_data_20;  
      regfile[write_addr_21]   <= io_writePorts_bits_data_21;    
      regfile[write_addr_22]   <= io_writePorts_bits_data_22;
      regfile[write_addr_23]   <= io_writePorts_bits_data_23;     
      regfile[write_addr_24]   <= io_writePorts_bits_data_24;    
    end       
  end
end

// Read Ports
assign read_addr_1 = read_addr[6:0] + 2'b01;
assign read_addr_2 = read_addr[6:0] + 2'b10;
assign read_addr_3 = read_addr[6:0] + 2'b11;

assign io_readPort_bits_0 = io_readPort_valid ? regfile[read_addr[6:0]] : 0;
assign io_readPort_bits_1 = io_readPort_valid ? regfile[read_addr_1]    : 0;
assign io_readPort_bits_2 = io_readPort_valid ? regfile[read_addr_2]    : 0;
assign io_readPort_bits_3 = io_readPort_valid ? regfile[read_addr_3]    : 0;



assign carry_wr = write_addr[FIFO_ADDR_DEPTH];
always_ff @(posedge clk_i or negedge rst_ni) 
begin
  if(rst_ni) 
  begin
     write_addr <= 0;
  end
  else 
  begin
    if(write_en && ~fifo_full)
    begin
      write_addr <= write_addr + io_writePorts_bits_validNum;
   end
  end
end
// Write Enable 
assign write_en   = io_writePorts_valid & io_writePorts_ready;
// FIFO  Full 
assign carry_full = write_full[FIFO_ADDR_DEPTH];
assign write_full = write_addr + 5'b11001;
always_comb
begin
  if(carry_wr == carry_rd)
  begin
    if(carry_full == carry_rd)
    begin
      fifo_full = 0;
    end
    else
    begin
      fifo_full = (write_full[6:0] > read_addr[6:0]) || (write_full[6:0] == read_addr[6:0]);
    end
  end
  else
  begin
    if(carry_full != carry_rd)
    begin
      fifo_full = (write_full[6:0] > read_addr[6:0]) || (write_full[6:0] == read_addr[6:0]);
    end
    else
    begin
      fifo_full = 1;
    end
  end
end
assign io_writePorts_ready = ~fifo_full;


assign carry_rd = read_addr[FIFO_ADDR_DEPTH];
always_ff @(posedge clk_i or negedge rst_ni) 
begin
  if(rst_ni) 
  begin
     read_addr  <= 0;
  end
  else 
  begin
    if(read_en && ~fifo_empty)
      read_addr <= read_addr + 3'b100;
  end
end
// Read  Enable 
assign read_en     = io_readPort_valid & io_readPort_ready;
// FIFO  Empty
assign read_empty  = read_addr + 3'b100;
assign carry_empty = read_empty[FIFO_ADDR_DEPTH];
always_comb
begin
  if(carry_wr == carry_rd)
  begin
    if(carry_wr == carry_empty)
    begin
      fifo_empty = ~(write_addr[6:0] > read_empty[6:0]) || (write_addr[6:0] == read_empty[6:0]);
    end
    else
    begin
      fifo_empty = 1;
    end
  end
  else
  begin
    if(carry_wr == carry_empty)
    begin
      fifo_empty = ~(write_addr[6:0] > read_empty[6:0]) || (write_addr[6:0] == read_empty[6:0]);
    end
    else
    begin
      fifo_empty = 0;
    end
  end
end
assign io_readPort_valid = ~fifo_empty;

endmodule