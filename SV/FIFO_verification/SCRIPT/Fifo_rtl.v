//RTL
module fifo(clk,rst,wdata,rdata,wr_en,rd_en,full,empty);

        input  clk,rst,wr_en,rd_en;
        output  full,empty;
        input  [7:0] wdata;
        output reg [7:0] rdata;
        reg     [5:0] wr_ptr;
        reg     [5:0] rd_ptr;
        reg     [7:0] mem [31:0];
        integer  i;

        //writing data in to fifo
always @(posedge clk,posedge rst)
        if(rst) begin
        for(i=0;i<32;i=i+1)
                mem[i] <= 8'b0;
        //wr_ptr<=1'b0;
end else if(wr_en & ~ full)
                mem[wr_ptr]<=wdata;
        //reading from fifo

always @(posedge clk,posedge rst)
        if(rst) begin
        rdata <= 8'b0;

end else if(rd_en & ~ empty)
                rdata<=mem[rd_ptr];

        //generating write pointer
always @(posedge clk,posedge rst)
        if(rst)
                wr_ptr <= 6'b0;
else if(wr_en & ~ full)
        wr_ptr=wr_ptr+1;

always @(posedge clk,posedge rst)
        if(rst)
                rd_ptr <= 6'b0;
else if(rd_en & ~ empty)
        rd_ptr=rd_ptr+1;

assign empty = (wr_ptr==rd_ptr);
assign full  = ((wr_ptr[4:0]==rd_ptr[4:0]) && (wr_ptr[5]!=rd_ptr[5]));
endmodule