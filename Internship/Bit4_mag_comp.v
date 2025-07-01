module Bit4_mag_comp(Equal,Greater,Small,A,B);
    input [3:0]A,B;
    output  Equal,Greater,Small;
    assign Equal=(A==B);
    assign Greater=(A>B);
    assign Small=(A<B);
endmodule                                                                                                                                                        
