![](../../workflows/gds/badge.svg)

## TT GDS Macro BlackBox Testing

A repository for testing blackbox GDS art integration into TT tiles.

_Note: Work In Progress, see top of `config.json`_

**Getting Started**

GDSPY is required to add boundary layers to GDS files: `apt install python3-gdspy`

- First, `git submodule update --init`.
- Place your magic art designs in `mag/` or `gds/`
- run `make preproc <name_of_macro_in_gds_or_mag>`
  - This will produce GDS/LEF outputs used during a Openlane2 custom flow.
  - Additionally, a PN boundary layer will be added to any converted GDS or converted MAG during the preproc phase.
- Make a copy of `src/ttlogo_config.json` as `src/<my_macro_name>_config.json`
   - Edit the `VERILOG_DEFINES` and `MACROS` options to specify which macro you would like to place.
- Run `make tt_harden_top <my_macro_name>`

**Things to be done**

- [X] (Fix the flow properly stream out the GDS, GDS -> isn't including PR boundary)
- [X] (Make sure we support input mags that have power nets that we will eventually ignore)
- [X] (The PDN config is basically a no-op. we can interleave configs for mags that needs a POWER net)
- [ ] (Standardize and document minimal flow required to macro place without detailed or global routing)
- [ ] (Alow the usage of multiple macros in the blackbox using a generate verilog statement)
