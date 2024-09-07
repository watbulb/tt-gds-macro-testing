/*
 * Copyright (c) 2024 TT Contributors
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "blackbox.v"

module tt_um_macro_test_wrapper (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] can be used
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  assign uo_out  = '0;
  assign uio_out = '0;
  assign uio_oe  = '0;
  wire _unused   = &{ena, clk, rst_n, ui_in, uio_in, /*ua,*/ 1'b0};

  // instantiate the blackbox GDS macro 
  (* keep *) `BLACKBOX_NAME `BLACKBOX_INSTANCE ();
endmodule
