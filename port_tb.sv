//------------------------------------------------------------------------------
// File        : Dual Port RAM 
// Author      : Rajat Athani / 1BM24EC417
// Created     : 2026-02-04
// Module      : Dual Port RAM 
// Project     : SystemVerilog and Verification (23EC6PE2SV)
// Faculty     : Prof. Ajaykumar Devarapalli
//
// Description : Verifies read and write functionality of Dual Port RAM.
//------------------------------------------------------------------------------

module tb;

  localparam ADDR_W = 8;
  localparam DATA_W = 8;

  logic clk = 0;
  logic we;
  logic [ADDR_W-1:0] waddr, raddr;
  logic [DATA_W-1:0] wdata, rdata;

  // DUT
  dual_port_ram #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) dut (
    .clk(clk),
    .we(we),
    .waddr(waddr),
    .wdata(wdata),
    .raddr(raddr),
    .rdata(rdata)
  );

  // Clock
  always #5 clk = ~clk;

  // Reference model using associative array
  byte ref_mem [int];

  int i;
  byte exp;

  initial begin
    we = 0;
    waddr = 0; wdata = 0; raddr = 0;

    // Random write + readback
    repeat (20) begin
      // Random write
      waddr = $urandom_range(0, (1<<ADDR_W)-1);
      wdata = $urandom();
      we    = 1;

      @(posedge clk);
      we = 0;

      // Update reference model
      ref_mem[waddr] = wdata;

      // Read back
      raddr = waddr;
      @(posedge clk); // wait for sync read

      exp = ref_mem[waddr];

      if (rdata === exp)
        $display("PASS : Addr=%0d Data=%0h", waddr, rdata);
      else
        $display("FAIL : Addr=%0d Exp=%0h Got=%0h", waddr, exp, rdata);
    end

    $finish;
  end

endmodule
