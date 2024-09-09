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

        
        #10;
        rst = 0;
        #10;

        // Test Case 1: Read Operation
        
        fifo_read_en = 1;
      	fifo_empty = 0;
        
        fifo_data_in = 32'h1a2a3a4a;  // address
      	#10;
        //$display("HERE01 fifo_data_in = %h", fifo_data_in);
        //$display("HERE02 wb_adr_o = %h", wb_adr_o);

        #10;
        

        //WB slave sending data and acknowledgment
        #10;
        wb_dat_i = 32'hffffffff;  // read data
        wb_ack_i = 1;
      	//$display("HERE04 wb_dat_i = %h", wb_dat_i);
      	#10;
      	//$display("HERE04 fifo_data_out = %h", fifo_data_out);
        #10;
        wb_ack_i = 0;

        wait(wb_cyc_o == 0 && wb_stb_o == 0);
		fifo_read_en = 0;
        // Check the result
      	if (fifo_data_out != 32'hffffffff) begin
            $display("Read data mismatch");
        end else begin
            $display("Read data correct");
        end
      
      	#50
      
      	//reset
      	rst = 1;
      	#10
      	rst = 0;
      
      	#20
      
        // Test Case 2: Write Operation
        //write request
        fifo_empty = 0;
        fifo_write_en = 1;
        fifo_data_in = 32'h1b2b3b4b; // address

        #10;
        
      
      	wb_ack_i = 1;
        #10;
        //wb_ack_i = 0;

        //WB slave acknowledgment
        #20;
      	fifo_data_in = 32'heeeeeeee; // data
      	
        //#10;

        //transaction complete
        wait(wb_cyc_o == 0 && wb_stb_o == 0);
      	fifo_write_en = 0;
      	wb_ack_i = 0;
		
      if (fifo_data_in != 32'heeeeeeee && wb_cyc_o == 0 && wb_stb_o == 0) begin
        $display("Write data mismatch");
        end else begin
          $display("Write data correct");
        end
        // End the simulation
        #50;
        $finish;
    end 

endmodule