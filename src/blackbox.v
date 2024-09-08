`ifndef BLACKBOX_NAME
`define BLACKBOX_NAME blackbox
`endif
`ifndef BLACKBOX_INSTANCE
`define BLACKBOX_INSTANCE um_blackbox
`endif

(* blackbox *) (* keep *)
module `BLACKBOX_NAME (
`ifdef USE_POWER_PINS
  input VPWR,
  input VGND
`endif
);
endmodule

