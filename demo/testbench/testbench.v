`timescale 1 ns / 1 ps

module testbench();

    reg clk = 1'b1;
    reg reset = 1'b1;

    always #5 clk = ~clk;

    initial begin
    		if ($test$plusargs("vcd")) begin
			$dumpfile("rv32_toy.vcd");
			$dumpvars(0, testbench);
		end
        #100;
        reset = 1'b0;

		repeat (1000000) @(posedge clk);
		$display("TIMEOUT");
		$finish;
    end

    //addr init as 32'h80000000
    wire [31:0] imem_addr;
    reg         imem_resp_valid;
    reg  [31:0] imem_data;
    
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire        dmem_req_valid;
    reg  [31:0] dmem_rdata;
    reg         dmem_resp_valid;
    wire        dmem_fcn;
    wire [2:0]  dmem_typ;

    Core rv32_toy(
        .clock(clk), 
        .reset(reset), 
        .io_imem_req_bits_addr(imem_addr),
        .io_imem_resp_valid(imem_resp_valid),
        .io_imem_resp_bits_data(imem_data),

        .io_dmem_req_valid(dmem_req_valid),
        .io_dmem_req_bits_addr(dmem_addr),
        .io_dmem_req_bits_data(dmem_wdata),
        .io_dmem_req_bits_fcn(dmem_fcn),
        .io_dmem_req_bits_typ(dmem_typ),
        .io_dmem_resp_valid(dmem_resp_valid),
        .io_dmem_resp_bits_data(dmem_rdata)
    );

    // emulated memory
    localparam MEM_SIZE = 4*1024*32;        //128KB  
    localparam MEM_WIDTH = 10+5;
    reg [31:0] memory [0:MEM_SIZE/4-1];
    initial $readmemh("firmware.hex", memory);

    // emulated seria
    always @(posedge clk) begin
        if (~reset && dmem_addr == 32'h1000_0000 && dmem_req_valid && dmem_fcn) begin
            $write("%c", dmem_wdata[7:0]);
        end
        if (dmem_addr == 32'h2000_0000 && dmem_wdata[31:0] == 123456789)
            $finish;            
    end


    // imem fetch inst
    always @(posedge clk) begin
        if (reset) begin
            imem_resp_valid <= 1'b0;
        end else begin
            imem_resp_valid <= 1'b1;
        end
    end

    always @(posedge clk) begin
        imem_data <= memory[imem_addr[MEM_WIDTH+1 : 2]];
    end

    // dmem load and store
    always @(posedge clk) begin
        if (reset) begin
            dmem_resp_valid <= 1'b0;
        end
        else begin
            dmem_resp_valid <= dmem_req_valid;
        end
    end

    
    reg [3:0] mem_wstr;
    always @(*) begin
        if (dmem_typ == 3'b011 || dmem_typ == 3'b111) begin       // lw lwu sw swu
            mem_wstr <= 4'b1111;
        end
        else if (dmem_typ == 3'b010 || dmem_typ == 3'b110) begin  // lh lhu sh shu
            if (dmem_addr[1])               // high half
                mem_wstr <= 4'b1100;
            else
                mem_wstr <= 4'b0011;
        end
        else if (dmem_typ == 3'b001 || dmem_typ == 3'b101) begin  // lb lbu sb sbu
            if (dmem_addr[1:0] == 2'b00)        // 1st byte
                mem_wstr <= 4'b0001;
            else if (dmem_addr[1:0] == 2'b01)   // 2st byte
                mem_wstr <= 4'b0010;
            else if (dmem_addr[1:0] == 2'b10)   // 3st byte
                mem_wstr <= 4'b0100;
            else                                // 4st byte
                mem_wstr <= 4'b1000;
        end
        else begin
            mem_wstr <= 4'b0;
        end
    end


    always @(posedge clk) begin
        if (dmem_req_valid && ~dmem_fcn) begin  // load
            if (mem_wstr == 4'b1111)            // lw
                dmem_rdata <= memory[dmem_addr[MEM_WIDTH+1 : 2]];
            else if (mem_wstr == 4'b1100) begin       
                if (dmem_typ == 3'b010)         // lh
                    dmem_rdata <= {{16{memory[dmem_addr[MEM_WIDTH+1 : 2]][31]}}, memory[dmem_addr[MEM_WIDTH+1 : 2]][31:16]};
                else                            // lhu
                    dmem_rdata <= {16'b0, memory[dmem_addr[MEM_WIDTH+1 : 2]][31:16]};
            end
            else if (mem_wstr == 4'b0011)   begin
                if (dmem_typ == 3'b010)         // lh
                    dmem_rdata <= {{16{memory[dmem_addr[MEM_WIDTH+1 : 2]][15]}}, memory[dmem_addr[MEM_WIDTH+1 : 2]][15:0]};
                else                            // lhu
                    dmem_rdata <= {16'b0, memory[dmem_addr[MEM_WIDTH+1 : 2]][15:0]};
            end
            else if (mem_wstr == 4'b0001) begin
                if (dmem_typ == 4'b001)         // lb
                    dmem_rdata <= {{24{memory[dmem_addr[MEM_WIDTH+1 : 2]][7]}}, memory[dmem_addr[MEM_WIDTH+1 : 2]][7:0]};
                else                            // lbu
                    dmem_rdata <= {24'b0, memory[dmem_addr[MEM_WIDTH+1 : 2]][7:0]};
            end
            else if (mem_wstr == 4'b0010) begin
                if (dmem_typ == 4'b001)         // lb
                    dmem_rdata <= {{24{memory[dmem_addr[MEM_WIDTH+1 : 2]][15]}}, memory[dmem_addr[MEM_WIDTH+1 : 2]][15:8]};
                else                            // lbu
                    dmem_rdata <= {24'b0, memory[dmem_addr[MEM_WIDTH+1 : 2]][15:8]};
            end
            else if (mem_wstr == 4'b0100) begin
                if (dmem_typ == 4'b001)         // lb
                    dmem_rdata <= {{24{memory[dmem_addr[MEM_WIDTH+1 : 2]][23]}}, memory[dmem_addr[MEM_WIDTH+1 : 2]][23:16]};
                else                            // lbu
                    dmem_rdata <= {24'b0, memory[dmem_addr[MEM_WIDTH+1 : 2]][23:16]};
            end
            else if (mem_wstr == 4'b1000) begin
                if (dmem_typ == 4'b001)         // lb
                    dmem_rdata <= {{24{memory[dmem_addr[MEM_WIDTH+1 : 2]][31]}}, memory[dmem_addr[MEM_WIDTH+1 : 2]][31:24]};
                else                            // lbu
                    dmem_rdata <= {24'b0, memory[dmem_addr[MEM_WIDTH+1 : 2]][31:24]};
            end
            else begin
                dmem_rdata <= 32'h0;
            end
        end
    end
    

    always @(posedge clk) begin
        if (dmem_req_valid && dmem_fcn) begin // store
            if (mem_wstr == 4'b1111) 
                memory[dmem_addr[MEM_WIDTH+1 : 2]] <= dmem_wdata;
            else if (mem_wstr == 4'b1100) 
                memory[dmem_addr[MEM_WIDTH+1 : 2]][31 : 16] <= dmem_wdata[15 : 0];
            else if (mem_wstr == 4'b0011) 
                memory[dmem_addr[MEM_WIDTH+1 : 2]][15 :  0] <= dmem_wdata[15 : 0];
            else if (mem_wstr == 4'b0001) 
                memory[dmem_addr[MEM_WIDTH+1 : 2]][ 7 :  0] <= dmem_wdata[ 7 : 0];
            else if (mem_wstr == 4'b0010)
                memory[dmem_addr[MEM_WIDTH+1 : 2]][15 :  8] <= dmem_wdata[ 7 : 0];
            else if (mem_wstr == 4'b0100)
                memory[dmem_addr[MEM_WIDTH+1 : 2]][23 : 16] <= dmem_wdata[ 7 : 0];
            else if (mem_wstr == 4'b1000)
                memory[dmem_addr[MEM_WIDTH+1 : 2]][31 : 24] <= dmem_wdata[ 7 : 0];
            else
                $display("memory store Error!");
        end
     end

endmodule
