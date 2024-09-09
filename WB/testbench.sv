// Code your testbench here
// or browse Examples
module tb_Wishbone_master();

    // Clock and reset
    reg clk;
    reg rst;

    // Wishbone Interface signals
    wire wb_cyc_o;
    wire wb_stb_o;
    wire wb_we_o;
    wire [31:0] wb_adr_o;
    wire [31:0] wb_dat_o;
    reg [31:0] wb_dat_i;
    reg wb_ack_i;

    // FIFO Interface signals
    reg fifo_read_en;
    reg fifo_write_en;
    reg fifo_empty;
    reg [31:0] fifo_data_in;
    wire [31:0] fifo_data_out;

    // Instantiate the Wishbone Master module
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Testbench procedure
    initial begin
        // Initialize signals
        rst = 1;
        fifo_read_en = 0;
        fifo_write_en = 0;
        fifo_empty = 0;
        fifo_data_in = 0;
        wb_dat_i = 0;
        wb_ack_i = 0;

        // Apply reset
        #15;
        rst = 0;
        #15;

        // Test Case 1: Read Operation
        
        fifo_read_en = 1;
      	fifo_empty = 1;
        #15;
        fifo_data_in = 32'h5A5A5A5A;  // address
      
        $display("HERE01 fifo_data_in = %h", fifo_data_in);
        $display("HERE02 wb_adr_o = %h", wb_adr_o);

        #10;
        fifo_read_en = 0;

        // Simulate Wishbone slave sending data and acknowledgment
        #20;
        wb_dat_i = 32'hDEADBEEF;  // Example read data
        wb_ack_i = 1;
        #10;
        wb_ack_i = 0;

        // Wait for the Wishbone transaction to complete
        wait(wb_cyc_o == 0 && wb_stb_o == 0);

        // Check the result
        if (fifo_data_out != 32'hDEADBEEF) begin
            $display("Read data mismatch");
        end else begin
            $display("Read data correct");
        end

        // End the simulation
        #50;
        $stop;
    end

endmodule