module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001; 
localparam CHK_CMD   = 3'b010; 
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100; 

input MOSI, clk, rst_n, SS_n, tx_valid;
input  [7:0] tx_data;
output reg [9:0] rx_data;
output reg  rx_valid, MISO;

reg [3:0] counter;
reg  received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin 
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin //mosi =1 , ssn =0
                    if (received_address) 
                        ns = READ_DATA; // FIXED changed from read addr to data
                    else
                        ns = READ_ADD;// FIXED changed from read data to addr
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin 
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0; 
        counter <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0 ) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0 ) begin
                        MISO <= tx_data[counter-1]; 
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 9;  /// BUG FIXED
                    end
                end
                
            end
            default : begin
                counter <= 0;
                MISO <= 1'b0;
            end
        endcase
        end
    end

//Assertions

property assert_reset;
    @(posedge clk) (!rst_n) |=> (!MISO && rx_data=='0 &&rx_valid=='0);
endproperty
assert property(assert_reset);
cover property (assert_reset);


property write_add_seq;
  @(posedge clk) disable iff(!rst_n)
     ($fell(SS_n) ##1(!MOSI)[*3] ) |-> ##10 ( rx_valid ##[0:$] SS_n); 
endproperty

assert property(write_add_seq);
cover property(write_add_seq);

property write_data_seq;
  @(posedge clk) disable iff(!rst_n)
     ( $fell(SS_n) ##1(!MOSI)[*2] ##1 (MOSI) ) |-> ##10 ( rx_valid ##[0:$] SS_n); 
endproperty

assert property(write_data_seq);
cover property(write_data_seq);

property read_add_seq;
  @(posedge clk) disable iff(!rst_n)
     ( $fell(SS_n) ##1(MOSI)[*2] ##1 (!MOSI) ) |-> ##10 (rx_valid ##[0:$] SS_n); 
endproperty

assert property(read_add_seq);
cover property(read_add_seq);

property read_data_seq;
  @(posedge clk) disable iff(!rst_n)
     ($fell(SS_n) ##1(MOSI)[*3]  ) |-> ##10 (rx_valid ##[0:$] SS_n); 
endproperty

assert property(read_data_seq);
cover property(read_data_seq);




property idle_to_check_cmd;
  @(posedge clk) disable iff(!rst_n)
    (cs == IDLE && !SS_n) |-> (ns==CHK_CMD);
endproperty
assert property (idle_to_check_cmd);
cover property (idle_to_check_cmd);

// 2) CHK_CMD >> WRITE or READ_ADDR or READ_DATA
property check_cmd_to_write;
  @(posedge clk) disable iff(!rst_n)
    (cs == CHK_CMD && !SS_n && !MOSI) |-> (ns == WRITE );
endproperty
assert property (check_cmd_to_write);
cover property (check_cmd_to_write);

property check_cmd_to_read_addr;
  @(posedge clk) disable iff(!rst_n)
    (cs == CHK_CMD && !SS_n && MOSI && !received_address) |-> (ns == READ_ADD);
endproperty
assert property (check_cmd_to_read_addr);
cover property (check_cmd_to_read_addr);

property check_cmd_to_read_data;
  @(posedge clk) disable iff(!rst_n)
    (cs == CHK_CMD && !SS_n && MOSI && received_address) |-> (ns == READ_DATA);
endproperty
assert property (check_cmd_to_read_data);
cover property (check_cmd_to_read_data);

// 3) WRITE >> IDLE
property write_to_idle;
  @(posedge clk) disable iff(!rst_n)
    (cs == WRITE && SS_n)|-> (ns == IDLE);
endproperty
assert property (write_to_idle);
cover property (write_to_idle);

// 4) READ_ADD >> IDLE
property read_add_to_idle;
  @(posedge clk) disable iff(!rst_n)
    (cs == READ_ADD && SS_n) |-> (ns == IDLE);
endproperty
assert property (read_add_to_idle);
cover property (read_add_to_idle);

// 5) READ_DATA >> IDLE
property read_data_to_idle;
  @(posedge clk) disable iff(!rst_n)
    (cs == READ_DATA && SS_n) |->  (ns == IDLE);
endproperty
assert property (read_data_to_idle);
cover property (read_data_to_idle);


endmodule