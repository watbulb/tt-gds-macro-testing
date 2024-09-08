#!/usr/bin/env python3
import sys, os
import gdspy

BOUNDARY_LAYER = 235  # prBndry
BOUNDARY_DATATYPE = 4 # boundary

if __name__ == '__main__':

  # Check args
  if len(sys.argv) < 2:
    print(f"{sys.argv[0]} <file.gds>")
    print("warning: this script modifies the file in-place")
    exit(1)
  
  # Check filepath
  filepath: str = sys.argv.pop()
  if not os.path.isfile(filepath):
    raise FileNotFoundError("unable to locate GDS file specified")

  target_cellname: str = os.path.basename(filepath.split(".")[0])

  # Load GDS
  gdsii = gdspy.GdsLibrary(infile=filepath)
  if not target_cellname in gdsii.cells:
    raise RuntimeError("cannot locate a cell in the GDS file matching the filename")

  # Delete output driver cells
  target_cell: gdspy.Cell = gdsii.cells[target_cellname]

  if "sky130_fd_sc_hd__buf_2" in gdsii.cells:
    gdsii.remove(gdsii.cells["sky130_fd_sc_hd__buf_2"])
    print("removing: sky130_fd_sc_hd__buf_2")

  if "sky130_fd_sc_hd__conb_1" in gdsii.cells:
    gdsii.remove(gdsii.cells["sky130_fd_sc_hd__conb_1"])
    print("removing: sky130_fd_sc_hd__conb_1")

  print(gdsii.cells)
  gdsii.write_gds(filepath)
  print("Success")
  