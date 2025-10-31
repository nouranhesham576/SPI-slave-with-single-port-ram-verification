package SPI_Wrapper_shared_pkg;
    bit [5:0] count = 0;
    bit read_data_flag=0;
    bit read_addr_flag=0;
    logic [10:0] arr_of_data=11'b0;
    bit is_read=0;
    bit have_address_to_read=0;
    int limit=13;
endpackage