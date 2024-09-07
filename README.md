## TT GDS Macro BlackBox Testing

A repository for testing blackbox GDS art integration into TT tiles.

_Note: Work In Progress, see top of `config.json`_

**Getting Started**

- Place your magic art designs in `mag/` or `gds/`
- If your design is a `.mag`, run `make preproc <name_of_mag>`
  - This will produce GDS/LEF outputs used during a Openlane2 custom flow.

```bash
git submodule update --init
make preproc skullfet_logo
make harden_top
```

**Things to be done**

- [ ] (Fix the flow properly stream out the GDS, GDS -> isn't including PR boundary)
- [ ] (Dynamically generate macro inclusions into the config from a macros.cfg)
- [ ] (Standardize and document minimal flow required to macro place without detailed or global routing)
- [ ] (Make sure we support input mags that have power nets that we will eventually ignore)
- [ ] (The PDN config is basically a no-op. we can interleave configs for mags that needs a POWER net)
