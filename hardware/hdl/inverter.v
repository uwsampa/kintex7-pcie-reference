`timescale 1ns / 1ps

module inverter (
    input  wire CLK,
    input  wire RESET_N,

    input  wire [63:0] S_AXIS_TDATA,
    input  wire S_AXIS_TVALID,
    output wire S_AXIS_TREADY,
    input  wire S_AXIS_TLAST,
    
    output wire [63:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,
    input  wire M_AXIS_TREADY,
    output wire M_AXIS_TLAST
    );
    
    wire output_fifo_tvalid, output_fifo_tready, output_fifo_tlast;
    wire [63:0] input_fifo_tdata;
    
     axis_data_fifo_0 input_fifo (
      .s_axis_aresetn(RESET_N),
      .s_axis_aclk(CLK),
      .s_axis_tvalid(S_AXIS_TVALID),
      .s_axis_tready(S_AXIS_TREADY),
      .s_axis_tdata(S_AXIS_TDATA),
      .s_axis_tlast(S_AXIS_TLAST),
      .m_axis_tvalid(output_fifo_tvalid),
      .m_axis_tready(output_fifo_tready),
      .m_axis_tdata(input_fifo_tdata),
      .m_axis_tlast(output_fifo_tlast),
      .axis_data_count(),        // output wire [31 : 0] axis_data_count
      .axis_wr_data_count(),  // output wire [31 : 0] axis_wr_data_count
      .axis_rd_data_count()  // output wire [31 : 0] axis_rd_data_count
   );   
    wire [63:0] inverted_data;
    genvar i;
    for(i = 0; i < 8; i = i + 1) begin
        assign inverted_data[(i+1)*8 - 1 : i*8] = 255 - input_fifo_tdata[(i+1)*8 - 1 : i*8];
    end
        
    axis_data_fifo_0 output_fifo (
      .s_axis_aresetn(RESET_N),
      .s_axis_aclk(CLK),
      .s_axis_tvalid(output_fifo_tvalid),
      .s_axis_tready(output_fifo_tready),
      .s_axis_tdata(inverted_data),
      .s_axis_tlast(output_fifo_tlast),
      .m_axis_tvalid(M_AXIS_TVALID),
      .m_axis_tready(M_AXIS_TREADY),
      .m_axis_tdata(M_AXIS_TDATA),
      .m_axis_tlast(M_AXIS_TLAST),
      .axis_data_count(),        // output wire [31 : 0] axis_data_count
      .axis_wr_data_count(),  // output wire [31 : 0] axis_wr_data_count
      .axis_rd_data_count()  // output wire [31 : 0] axis_rd_data_count
   );

endmodule
