module Wishbone_master (
  input wire clk,
  input wire rst,

  // Wishbone Interface
  output reg wb_cyc_o,
  output reg wb_stb_o,
  output reg wb_we_o,
  output reg [31:0] wb_adr_o,
  output reg [31:0] wb_dat_o,

  input wire [31:0] wb_dat_i,
  input wire wb_ack_i,

  // FIFO Interface
  input wire fifo_read_en,
  input wire fifo_write_en,
  input wire fifo_empty,
  input wire [31:0] fifo_data_in,

  output reg [31:0] fifo_data_out
);

  // FSM States
  reg [2:0] state;
  reg [2:0] next_state;

  // State Definitions
  localparam IDLE       = 3'b000;
  localparam READ_REQ   = 3'b001;
  localparam READ_RESP  = 3'b010;
  localparam WRITE_REQ  = 3'b011;
  localparam WRITE_RESP = 3'b100;

  // FSM State Transitions
  always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // FSM Next State Logic and Outputs
  always @(*) begin
    next_state = state;
    
    case (state)
      IDLE: begin
        wb_cyc_o = 0;
    	wb_stb_o = 0;
        wb_we_o = 0;
        
        if (fifo_read_en && !fifo_empty) begin
          next_state = READ_REQ;
        end else if (fifo_write_en && !fifo_empty)
          next_state = WRITE_REQ;
      end

      READ_REQ: begin
        wb_cyc_o = 1;
        wb_stb_o = 1;
        wb_we_o = 0;  // Read operation
        
        //$display("HERE03 fifo_data_in = %h", fifo_data_in);
        wb_adr_o = fifo_data_in;

        next_state = READ_RESP;
      end

      READ_RESP: begin
        wb_cyc_o = 1;
        wb_stb_o = 1;

        if (wb_ack_i) begin
          fifo_data_out = wb_dat_i;
          next_state = IDLE;
        end
      end

      WRITE_REQ: begin
        wb_cyc_o = 1;
        wb_stb_o = 1;
        wb_we_o = 1;  // Write operation  
        
        wb_adr_o = fifo_data_in;
        
        if (wb_ack_i) begin
          next_state = WRITE_RESP;
        end
      end

      WRITE_RESP: begin
        wb_cyc_o = 1;
        wb_stb_o = 1;
        
  		wb_dat_o = fifo_data_in;

        if (wb_ack_i) begin
          next_state = IDLE;
        end
      end

      default: begin
        next_state = IDLE;
      end
    endcase
  end

endmodule