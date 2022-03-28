//--------------------------------------------------------------------
// Design Name : fulladder
// File Name   : fulladder.v
// Function    :  
// Designer    : Chen Xiaowei         - Nanyang technological University 
//                                    - Technische Universität München
// Email       : chen1408@e.ntu.edu.sg
// Blog        : haitianzhishang.github.io
//---------------------------------------------------------------------
module fulladder #(
  parameter  DATA_WIDTH = 32
)
(  
  input    [DATA_WIDTH-1 : 0] a,
  input    [DATA_WIDTH-1 : 0] b,
  input                       ci,
  output   [DATA_WIDTH-1 : 0] sum,
  output                      co
);

  integer i;  
  reg [DATA_WIDTH-1 : 0] g,p,s,c;

// Generate bit and propagate bit
  always @(*) 
  begin
    c[0] = ci;
    for(i=0; i< DATA_WIDTH-1; i=i+1)
    begin
     g[i]   = a[i] & b[i];
     p[i]   = a[i] ^ b[i]; 
     c[i+1] = g[i] | p[i]&c[i];
     s[i]   = p[i] ^ c[i];
    end
    g[DATA_WIDTH-1]   = a[DATA_WIDTH-1] & b[DATA_WIDTH-1];
    p[DATA_WIDTH-1]   = a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]; 
    s[DATA_WIDTH-1]   = p[DATA_WIDTH-1] ^ c[DATA_WIDTH-1];
  end
  
// Binding output
  assign sum    = s;
  assign co     = c[DATA_WIDTH-1];

endmodule : fulladder