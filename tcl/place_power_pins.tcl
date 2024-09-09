# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024 Tiny Tapeout LTD
# Authors:
#  - Uri Shaked
#  - Dayton Pidhirney

set POWER_STRIPE_WIDTH 2um;

# Power stripes: NET name, x position. You can add additional power stripes for each net, as needed.
set POWER_STRIPES {
    VPWR  1um
    VGND  4um
}

set TOP_NAME   [file tail $::env(TOP_NAME)]
set MACRO_NAME [file tail $::env(MACRO_NAME)]

# Load top-level mag
load mag/final/${TOP_NAME}.mag
lef read lef/final/${TOP_NAME}.lef

# Load macro GDS
gds read gds/${MACRO_NAME}.gds

# If we are pure art, we need to remove the output drivers from the template
if { [info exists ::env(PURE_ART)] && $::env(PURE_ART) != "" } {
    # cellname doesn't return bool, so we check the output list form for the
    # match as a boolean instead
    set cellname_list [cellname list exists sky130_fd_sc_hd__buf_2]
    if {[lsearch -exact $cellname_list sky130_fd_sc_hd__buf_2] != -1} {
        for {set i 0} {$i < 24} {incr i} {
            set formatted_i [format "%02d" $i]
            select cell "_$formatted_i\_"
            delete
        }
        select cell TIE_ZERO_zero_
        delete
    }
}

# Draw the power stripes
# --------------------------------
proc draw_power_stripe {name x} {
    global POWER_STRIPE_WIDTH
    box $x 5um $x 220.76um
    box width $POWER_STRIPE_WIDTH
    paint met4
    label $name FreeSans 0.25u -met4
    port make
    port use [expr {$name eq "VGND" ? "ground" : "power"}]
    port class bidirectional
    port connections n s e w
}

# You can extra power stripes, as you need.
foreach {name x} $POWER_STRIPES {
    puts "Drawing power stripe $name at $x"
    draw_power_stripe $name $x
}

# Save the layout and export MAG/GDS/LEF
# ----------------------------------
save mag/final/${TOP_NAME}
gds write gds/final/${TOP_NAME}.gds
lef write lef/final/${TOP_NAME}.lef -hide -pinonly