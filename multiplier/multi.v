//--------------------------------------------------------------------
// Design Name : multi
// File Name   : multi.v
// Function    :  
// Designer    : Chen Xiaowei         - Nanyang technological University 
//                                    - Technische Universität München
// Email       : chen1408@e.ntu.edu.sg
// Blog        : haitianzhishang.github.io
//---------------------------------------------------------------------
module multi #(
  parameter  IN_DATA_WIDTH  = 32,
  parameter  OUT_DATA_WIDTH = 64
)
(
  input    [IN_DATA_WIDTH-1: 0]   a,      
  input    [IN_DATA_WIDTH-1: 0]   b,    
  output   [OUT_DATA_WIDTH-1: 0]  c
  
);

localparam BOOTH_NUM      = IN_DATA_WIDTH/2+1;
localparam PPM_DATA_WITH  = IN_DATA_WIDTH+1; 
integer i;
integer j;


reg  [BOOTH_NUM-1: 0] m1;
reg  [BOOTH_NUM-1: 0] m2;
reg  [BOOTH_NUM-1: 0] s;
reg  [IN_DATA_WIDTH+3: 0] ppm        [BOOTH_NUM-1:0];
reg  [IN_DATA_WIDTH-1: 0] ppm_temp_0 [BOOTH_NUM-1:0];
wire [PPM_DATA_WITH-1: 0] ppm_temp_1 [BOOTH_NUM-1:0];
reg  [PPM_DATA_WITH-1: 0] ppm_temp_2 [BOOTH_NUM-1:0];
reg  [OUT_DATA_WIDTH-1: 0] sum;  



//Booth-2 encoding
always@(*) 
begin
  m1[0] = a[0];
  m2[0] = ~(a[0]|~(a[0]^a[1]));
  s[0]  = a[1];      
  for(i=1;i<BOOTH_NUM-1;i=i+1)
  begin
    m1[i] = a[2*i-1]^a[2*i];//01,10
    m2[i] = ~(a[2*i-1]^a[2*i]|~(a[2*i]^a[2*i+1]));//011,100
    s[i]  = a[2*i+1];
  end
  m1[BOOTH_NUM-1] = a[IN_DATA_WIDTH-1]^1'b0;
  m2[BOOTH_NUM-1] = 1'b0;
  s[BOOTH_NUM-1]  = 1'b0;
end
//Transfer Multiplicand to Two's Complement According to Sign of Booth Code
always @(*) 
begin
  for(i=0;i<BOOTH_NUM;i=i+1)
  begin
    for(j=0;j<IN_DATA_WIDTH;j=j+1)
      ppm_temp_0[i][j] = b[j]^s[i];
  end
end
genvar k;
generate
  for(k=0;k<BOOTH_NUM;k=k+1)
    nociadder #(
                .DATA_WIDTH(PPM_DATA_WITH)
      )sign_ex_adder(
                      .a  ({s[k],ppm_temp_0[k]}),
                      .b  ({32'b0,s[k]}),
                      .co (),
                      .sum(ppm_temp_1[k])
      );
endgenerate

//Partial Product Matric
always @(*) 
begin
  for(i=0;i<BOOTH_NUM;i=i+1)
  begin
    //First Bit
    ppm_temp_2[i][0] = (m1[i]&ppm_temp_1[i][0]);
    for(j=1;j<PPM_DATA_WITH-1;j=j+1)
      ppm_temp_2[i][j] = (m1[i]&ppm_temp_1[i][j])|(m2[i]&ppm_temp_1[i][j-1]);
    //Last Bit
    ppm_temp_2[i][PPM_DATA_WITH-1] = m2[i]&ppm_temp_1[i][IN_DATA_WIDTH-1];
  end
end

//Partial Product Matric Signed Extension
always @(*) 
begin
  for(i=0;i<BOOTH_NUM;i=i+1)
  begin
    if(i==0)
      ppm[i] = {~s[i],s[i],s[i], ppm_temp_2[i]};
    else if(i==BOOTH_NUM-1)
      ppm[i] = {3'b0, ppm_temp_2[i]};
    else
      ppm[i] = {2'b01, ~s[i], ppm_temp_2[i]};
  end
end
//Partial Product Matric Addition
/*always @(*) 
begin
  sum = 0;
  for(i=0;i<BOOTH_NUM;i=i+1)
    sum = sum + ppm[i];
end*/

assign c = sum;

endmodule : multi