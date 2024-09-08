![](../../workflows/gds/badge.svg)

## TT GDS Macro BlackBox Testing

A repository for testing blackbox GDS art integration into TT tiles.

_Note: Work In Progress_

---

## Requirements:
- GDSPY: `apt install python3-gdspy`
  - required to add boundary layers to GDS files and to remove output driver cells: 
- `rsvg-convert`: For SVG based input images


## Getting Started

### For Digital and Mixed Signal Designs:

1. First, `git submodule update --init`.
2. Place your magic art designs in `mag/` or `gds/`
3. run `make preproc <name_of_macro_in_gds_or_mag>`
   - This will produce GDS/LEF outputs used during a Openlane2 custom flow.
   - Additionally, a PN boundary layer will be added to any converted GDS or converted MAG during the preproc phase.
4. Make a copy of `src/ttlogo_config.json` as `src/<my_macro_name>_config.json`
   - Edit the `VERILOG_DEFINES` and `MACROS` inside the config options to specify which macro you would like to place.
5. Run `make tt_harden_top <my_macro_name>`

6. The output of your design should now be in `runs/wokwi/final`, now one last thing needs to be done
before submitting via adding your top-level macro to the `gds/final` folder. The output drivers need to
be removed from the final GDS. This can be done using the following command:
    - `./script/gds_rm_outputs.py runs/wokwi/final/gds/tt_um_macro_test_wrapper.gds`
    - _Note:_ Replace `tt_um_macro_test_wrapper` with the name of your top-level module.

7. Now the final design files can be copied to `gds/final` and `lef/final`:

```bash
cp runs/wokwi/final/gds/tt_um_macro_test_wrapper.gds gds/final
cp runs/wokwi/final/lef/tt_um_macro_test_wrapper.lef lef/final
```

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

