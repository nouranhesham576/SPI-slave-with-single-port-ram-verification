module spi_golden (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001; 
localparam CHK_CMD   = 3'b010; 
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100; 

input MOSI,SS_n,clk,rst_n,tx_valid ;
input [7:0] tx_data;
output reg [9:0] rx_data ;
output reg MISO,rx_valid;

reg read_addr_received ; // law b 1 y3ni yroh ygeb l data law b zero yero7 ll address
reg [3:0] counter; //tracks how many bits we’ve received

reg [2:0] current_state,next_state ;
always @(posedge clk) begin
    if (~rst_n)
        current_state <= IDLE ;
    else
        current_state <= next_state ; 
end

//Next state logic always block
always @(*) begin
    case (current_state)
        IDLE: begin
            if (SS_n == 0 ) next_state = CHK_CMD;
            else next_state = IDLE;
        end
        CHK_CMD: begin
            if (SS_n == 0 && MOSI == 1) begin
                if (read_addr_received)
                    next_state = READ_DATA;
                else
                    next_state = READ_ADD;
            end else if (SS_n == 0 && MOSI == 0) begin
                next_state = WRITE;
            end 
            else if (SS_n) begin
                next_state = IDLE ;
            end
        end
        WRITE: begin
            if (SS_n == 1) 
                next_state = IDLE;
            else 
                next_state = WRITE;
        end

        READ_ADD: begin
            if (SS_n == 1) begin
                next_state = IDLE;
            end
            else 
                next_state = READ_ADD;  
        end
        READ_DATA: begin
            if (SS_n == 1) 
                next_state = IDLE;
            else 
                next_state = READ_DATA;
        end

        default: next_state = IDLE;
    endcase
end

//Output logic always block
always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 0;
        rx_data <= 0;
        read_addr_received <= 0;
        MISO <= 1'b0;
        rx_valid <= 0;
    end
    else begin
        case (current_state)

IDLE:  begin 
            rx_valid <= 0;
        end

CHK_CMD: counter <= 10;

WRITE: begin
    if (counter >0) begin
            rx_data[counter-1] <= MOSI;
            counter <= counter - 1;
                end
            else rx_valid <= 1;
            end

READ_ADD: begin
        if (counter >0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
        else begin
                    rx_valid <= 1;
                    read_addr_received <= 1;
                end
            end

READ_DATA: begin
    if (tx_valid) begin
        rx_valid<=0;
        if (counter >0) begin
            MISO <= tx_data[counter-1];
            counter <= counter - 1;
        end
        else read_addr_received<=0;
    end
    else begin
        if (counter>0) begin
            rx_data[counter-1] <= MOSI;
            counter <= counter - 1;
        end
        else begin  
            rx_valid <= 1;
            counter<=9;
        end
    end
end

default: begin
            counter <= 0;
            MISO <= 1'b0;
            end
        endcase
    end
end
endmodule