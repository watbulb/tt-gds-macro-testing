![](../../workflows/gds_manual/badge.svg)

## TT GDS Macro BlackBox Testing

A repository for testing blackbox GDS art integration into TT tiles.

_Note: Work In Progress_

---

## Requirements:
- GDSPY: `apt install python3-gdspy`
  - required to add boundary layers to GDS files and to remove output driver cells: 
- `rsvg-convert`: For SVG based input images
- `magic` if your design is a pure art design, to manually add the VPWR, VGND nets and remove the output drivers.

## Getting Started

### For Digital and Mixed Signal Designs:

1. First, `git submodule update --init`.
2. Place your magic art designs in `mag/` or `gds/`
3. run `make preproc <name_of_macro_in_gds_or_mag>`
   - This will produce GDS/LEF outputs used during a Openlane2 custom flow.
   - Additionally, a PN boundary layer will be added to any converted GDS or converted MAG during the preproc phase.
4. Make a copy of `src/ttlogo_config.json` as `src/<my_macro_name>_config.json`
   - Edit the `VERILOG_DEFINES` and `MACROS` inside the config options to specify which macro you would like to place.
   - If you are using this to add a logo to an existing project, you need to delete the flow in the config, and use the normal classic flow.
5. Run `make tt_harden_top <my_macro_name>`.
   - If your design in purely art, and has no logic, please do: `PURE_ART=1 make tt_harden_top <my_macro_name>`
   - If you need to override the top module name set `TOP_NAME=` as well.
6. The final designs are now made available in {gds,mag,lef}/final.

---

### For analog designs:

For SVG macro art:

1. Place your target macro images inside `img/`
2. Convert SVG to PNG: `rsvg-convert img/my_image.svg -o img/my_image.png`
3. Convert the image to GDS with PN boundary:
    - `./script/make_gds.py -i img/my_image.png -c my_image -o gds/my_image.gds`
4. Manually import the resulting instance into your Magic design or other analog program.

TODO: Write a magic placement script for all of this.

---

### FAQ

Q: Why can't we support the analog flow with macros?

A: We can, it just makes no sense to and is needlessly complicated. Analog designs for TT aren't being used with openlane, so we should stick with analog methods as appropriate.
   

### Things to be done (TODO)

- [X] (Fix the flow properly stream out the GDS, GDS -> isn't including PR boundary)
- [X] (Make sure we support input mags that have power nets that we will eventually ignore)
- [X] (The PDN config is basically a no-op. we can interleave configs for mags that needs a POWER net)
- [ ] (Standardize and document minimal flow required to macro place without detailed or global routing)
- [ ] (Alow the usage of multiple macros in the blackbox using a generate verilog statement)
- [ ] (Write a analog magic art macro placement script)

