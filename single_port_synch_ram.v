module single_port_synch_ram #(parameter ADDR = 4,
parameter DEPTH = 8,
parameter WIDTH = 8)
(
    input clk, 
    input wr_rd,                    //wr_rd = 1 for write operation, = 0 for read opeartion
    input chip_sel,                 //cs = 1 for enabling RAM
    input op_en,                    //op_en = 1 for read operation , 0 for write opn
    input [ADDR-1:0] addr_in,
  
    inout [WIDTH-1:0] data_in_out   //single port inout port 
);

//RAM declaration
reg [WIDTH-1:0] ram [0:DEPTH-1];

//temp reg for output data
reg [WIDTH-1:0] r_temp_data_out;

//-------------------------------------------------------------------------------------------
//write data in RAM
//-------------------------------------------------------------------------------------------
always @(posedge clk ) begin
    if(chip_sel == 1'b0) begin                       //if chip select is disabled
      //data_in_out <= {WIDTH{1'bz}};
      ram[addr_in] <= 'hz;
    end
    else begin
        if (wr_rd == 1'b1 && op_en == 1'b0 ) begin   //write condition after cs = 1
            ram[addr_in] <= data_in_out;
        end     
    end
end

//--------------------------------------------------------------------------------------------
//read operation
//--------------------------------------------------------------------------------------------

//write data in temp reg
always @(negedge clk ) begin
    if(chip_sel == 1'b0) begin
        r_temp_data_out <= 'hz;
    end
    else begin
       r_temp_data_out <= ram[addr_in];            //read operation stored in reg
    end
end

//asynch output assignment to pin from output_reg 
assign  data_in_out = r_temp_data_out;

endmodule //single_port_synch_ram