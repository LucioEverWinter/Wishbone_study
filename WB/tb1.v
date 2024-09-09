module tb_Wishbone_master();

    // Clock and reset
    reg clk;
    reg rst;

    // Wishbone signals
    wire wb_cyc_o;
    wire wb_stb_o;
    wire wb_we_o;
    wire [31:0] wb_adr_o;
    wire [31:0] wb_dat_o;
    reg [31:0] wb_dat_i;
    reg wb_ack_i;

    // FIFO signals
    reg fifo_read_en;
    reg fifo_write_en;
    reg fifo_empty;
    reg [31:0] fifo_data_in;
    wire [31:0] fifo_data_out;

    Wishbone_master uut (
        .clk(clk),
        .rst(rst),
        .wb_cyc_o(wb_cyc_o),
        .wb_stb_o(wb_stb_o),
        .wb_we_o(wb_we_o),
        .wb_adr_o(wb_adr_o),
        .wb_dat_o(wb_dat_o),
        .wb_dat_i(wb_dat_i),
        .wb_ack_i(wb_ack_i),
        .fifo_read_en(fifo_read_en),
        .fifo_write_en(fifo_write_en),
        .fifo_empty(fifo_empty),
        .fifo_data_in(fifo_data_in),
        .fifo_data_out(fifo_data_out)
    );

    // Clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
  
	initial begin
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_Wishbone_master);
    end
  
    // Testbench
    initial begin
      rst = 1;
      fifo_read_en = 0;
      fifo_write_en = 0;
      fifo_empty = 1;
      fifo_data_in = 0;
      wb_dat_i = 0;
      wb_ack_i = 0;

      
        
    end 

endmodule