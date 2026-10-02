module Instruction_Memory(
    input [31:0] address,
    output [31:0] data
);
    reg [31:0] mem [80:0];
    
    initial begin
        // Initialize x1 = 0, x2 = 1
        mem[0] = 32'h00000093; // addi x1, x0, 0
        mem[1] = 32'h00100113; // addi x2, x0, 1
        
        // Store first two numbers
        mem[2] = 32'h00102023; // sw x1, 0(x0) = 0
        mem[3] = 32'h00202223; // sw x2, 4(x0) = 1
        
        // Generate Fibonacci numbers
        mem[4]  = 32'h002081B3; // add x3, x1, x2 => 0+1=1
        mem[5]  = 32'h00302423; // sw x3, 8(x0) => 1
        mem[6]  = 32'h002000B3; // add x1, x0, x2 => x1=1
        mem[7]  = 32'h00300133; // add x2, x0, x3 => x2=1
        
        mem[8]  = 32'h002081B3; // add x3, x1, x2 => 1+1=2
        mem[9]  = 32'h00302623; // sw x3, 12(x0) => 2
        mem[10] = 32'h002000B3; // add x1, x0, x2 => x1=1
        mem[11] = 32'h00300133; // add x2, x0, x3 => x2=2
        
        mem[12] = 32'h002081B3; // add x3, x1, x2 => 1+2=3
        mem[13] = 32'h00302823; // sw x3, 16(x0) => 3
        mem[14] = 32'h002000B3; // add x1, x0, x2 => x1=2
        mem[15] = 32'h00300133; // add x2, x0, x3 => x2=3
        
        mem[16] = 32'h002081B3; // add x3, x1, x2 => 2+3=5
        mem[17] = 32'h00302A23; // sw x3, 20(x0) => 5
        mem[18] = 32'h002000B3; // add x1, x0, x2 => x1=3
        mem[19] = 32'h00300133; // add x2, x0, x3 => x2=5
        
        mem[20] = 32'h002081B3; // add x3, x1, x2 => 3+5=8
        mem[21] = 32'h00302C23; // sw x3, 24(x0) => 8
        mem[22] = 32'h002000B3; // add x1, x0, x2 => x1=5
        mem[23] = 32'h00300133; // add x2, x0, x3 => x2=8
        
        mem[24] = 32'h002081B3; // add x3, x1, x2 => 5+8=13
        mem[25] = 32'h00302E23; // sw x3, 28(x0) => 13
        mem[26] = 32'h002000B3; // add x1, x0, x2 => x1=8
        mem[27] = 32'h00300133; // add x2, x0, x3 => x2=13
        
        // Continue pattern for more Fibonacci numbers...
        mem[28] = 32'h002081B3; // add x3, x1, x2 => 8+13=21
        mem[29] = 32'h003020A3; // sw x3, 32(x0) => 21
        mem[30] = 32'h002000B3; // add x1, x0, x2 => x1=13
        mem[31] = 32'h00300133; // add x2, x0, x3 => x2=21
        
        // Add more instructions as needed...
        // (truncated for space - include your full fibonacci sequence)
    end
    
    assign data = mem[address[31:2]];
endmodule