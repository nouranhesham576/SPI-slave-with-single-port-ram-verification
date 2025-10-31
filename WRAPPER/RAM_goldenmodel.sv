module RAM_golden (clk,rst_n,din,rx_valid,dout,tx_valid);
parameter MEM_DEPTH =256 ;
parameter ADDR_SIZE =8 ;
input clk,rst_n,rx_valid;
input [9:0]din;
output reg [7:0]dout;
output reg tx_valid;

reg[7:0] write_addr;
reg [7:0] read_addr;
reg [7:0] mem [MEM_DEPTH-1:0];  //memory in hexa so (00)=8'b0 >>in mem.txt

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
      dout<=8'b0;
      tx_valid <= 1'b0;
      read_addr<= 8'b0;
      write_addr<= 8'b0;
  end
  else  begin
    if (rx_valid) begin
      case (din[9:8])
        2'b00: begin
          write_addr<=din[7:0]; //hold
          tx_valid <= 1'b0;
        end
        2'b01: begin
          mem[write_addr]<=din[7:0]; //write 
          tx_valid <= 1'b0;
        end
        2'b10: begin
          read_addr<=din[7:0] ;
          tx_valid <= 1'b0;
        end
        2'b11: begin
          dout <= mem[read_addr]; //read
          tx_valid <= 1'b1;
        end 
        default: begin
          dout <= 0;
          tx_valid <= 0;
        end
      endcase
    end
    else begin
      tx_valid <= 1'b0;
    end
    //tx_valid <= (din[9] && din[8] && rx_valid) ? 1'b1 : 1'b0;
  end
end
endmodule