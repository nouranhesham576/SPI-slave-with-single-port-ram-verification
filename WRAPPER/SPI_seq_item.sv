package SPI_seq_item_pkg;
import SPI_shared_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

class SPI_seq_item extends uvm_sequence_item;
`uvm_object_utils(SPI_seq_item)

bit clk ;
rand logic MOSI , SS_n, rst_n, tx_valid;
rand logic [7:0] tx_data;
rand logic [10:0] MOSI_data;  // 11-bit array 

// DUT outputs
logic [9:0] rx_data;
logic MISO, rx_valid;  

// Golden model outputs
logic [9:0] rx_data_golden;
logic MISO_golden, rx_valid_golden;  

function new(string name = "SPI_seq_item");
    super.new(name);
endfunction 

function string convert2string();
    return $sformatf("rst_n=%0b, SS_n=%0b, MOSI_data=0x%0h, tx_data=0x%0h, tx_valid=%0b | DUT: MISO=%0b rx_data=0x%0h rx_valid=%0b | GOLD: MISO=%0b rx_data=0x%0h rx_valid=%0b",
                     rst_n, SS_n, MOSI_data, tx_data, tx_valid, 
                     MISO, rx_data, rx_valid, 
                     MISO_golden, rx_data_golden, rx_valid_golden);
endfunction

function string convert2string_stimulus();
    return $sformatf("rst_n=%0b, SS_n=%0b, MOSI_data=0x%0h, tx_data=0x%0h, tx_valid=%0b",
                     rst_n, SS_n, MOSI_data,  tx_data, tx_valid);
endfunction

constraint reset_constraint { 
    rst_n dist { 0 := 5, 1 := 95 };
}

constraint valid_MOSI_command {
            MOSI_data[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
        }

constraint ready_to_read {
            if(count>=15) tx_valid ==1;
            else tx_valid == 0;
        }

function void post_randomize();
       if(count == 0) arr_of_data = MOSI_data;  
     is_read = (arr_of_data[10:8] == 3'b111)? 1:0;
            limit = (is_read)? 23:13;

            SS_n = (count == limit)? 1:0;

            if(arr_of_data[10:8] == 3'b110) have_address_to_read = 1'b1;
            if (is_read || (!rst_n)) have_address_to_read = 1'b0;

            //
            if((count > 0) && (count < 12)) begin
                MOSI = arr_of_data [11-count];
            end

            //count
            if (!rst_n) begin
                count = 0;
            end
            else begin
                if (count == limit) count = 0; 
                else count++;
            end

endfunction

endclass
endpackage