//------------------------------------------------------------------------------
// File        : Dual Port RAM 
// Author      : Rajat Athani / 1BM24EC417
// Created     : 2026-02-04
// Module      : Dual Port RAM 
// Project     : SystemVerilog and Verification (23EC6PE2SV)
// Faculty     : Prof. Ajaykumar Devarapalli
//
// Description : Dual Port RAM supporting simultaneous read and write operations.
//------------------------------------------------------------------------------

module dual_port_ram #(
  parameter ADDR_W = 8,
  parameter DATA_W = 8
)(
  input  logic                 clk,
  // Port A : Write
  input  logic                 we,
  input  logic [ADDR_W-1:0]    waddr,
  input  logic [DATA_W-1:0]    wdata,
  // Port B : Read
  input  logic [ADDR_W-1:0]    raddr,
  output logic [DATA_W-1:0]    rdata
);

  logic [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];

  // Write port
  always_ff @(posedge clk) begin
    if (we)
      mem[waddr] <= wdata;
  end

  // Read port (sync read)
  always_ff @(posedge clk) begin
    rdata <= mem[raddr];
  end

endmodule
