module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);

  input [9:0] din;
  input clk, rst_n, rx_valid;

  output reg [7:0] dout;
  output reg tx_valid;

  reg [7:0] MEM[255:0];

  reg [7:0] Rd_Addr, Wr_Addr;

  always @(posedge clk) begin
    if (~rst_n) begin
      dout <= 0;
      tx_valid <= 0;
      Rd_Addr <= 0;
      Wr_Addr <= 0;
    end else begin
      if (rx_valid) begin  //  mkntsh mawgoda 
        case (din[9:8])
          2'b00:   Wr_Addr <= din[7:0];
          2'b01:   MEM[Wr_Addr] <= din[7:0];
          2'b10:   Rd_Addr <= din[7:0];
          2'b11:   dout <= MEM[Rd_Addr];  //rd instead of wr 
          default: dout <= 0;
        endcase
      end
      tx_valid <= (din[9] && din[8] && rx_valid) ? 1'b1 : 1'b0;
    end
  end

//ASSERTIONS
  property reset_sva;
    @(posedge clk) !rst_n |-> ##1 (tx_valid == 0 && dout == 0);
  endproperty
  assert property (reset_sva);
  cover property (reset_sva);

  property tx_valid_low;
    @(posedge clk) disable iff(!rst_n) (din[9:8] inside {2'b00,2'b01,2'b10}) |-> ##1 tx_valid==0;
  endproperty
  assert property (tx_valid_low);
  cover property (tx_valid_low);

  property tx_valid_high;
    @(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b11) |=> ##[1:$] $rose(
        tx_valid
    ) ##[1:$] $fell(
        tx_valid
    );
  endproperty

  assert property (tx_valid_high);
  cover property (tx_valid_high);

  property write_operation;
    @(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b00) |=> ##[1:$] (din[9:8] == 2'b01);
  endproperty
  assert property (write_operation);
  cover property (write_operation);

  property read_operation;
    @(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b10) |=> ##[1:$] (din[9:8] == 2'b11);
  endproperty
  assert property (read_operation);
  cover property (read_operation);

endmodule
