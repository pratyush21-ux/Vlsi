# STEP 13 : render the final GDS to PNG images with KLayout (batch mode)
# run: klayout -b -r 13_render.py
import os
import pya

# paths come from flow/env.sh; defaults let it also run without sourcing env.sh
res     = os.environ.get("RES", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "results"))
design  = os.environ.get("DESIGN", "simple_cpu_v4")
pdkpath = os.environ.get("PDKPATH", "/foss/pdks/sky130A")
gds  = f"{res}/10_gds/{design}.gds"
lyp  = f"{pdkpath}/libs.tech/klayout/tech/sky130A.lyp"
os.makedirs(f"{res}/13_images", exist_ok=True)

view = pya.LayoutView()
view.load_layout(gds, True)
view.load_layer_props(lyp)
view.max_hier()                                 # show inside the std cells too
view.set_config("background-color", "#000000")
view.set_config("grid-visible", "false")
view.set_config("text-visible", "false")

# full chip
view.zoom_fit()
view.save_image(f"{res}/13_images/chip_full.png", 1800, 1800)

# zoom: 30 x 30 um area in the middle of the core (cells, rails, wires, vias)
view.zoom_box(pya.DBox(100, 100, 130, 130))
view.save_image(f"{res}/13_images/chip_zoom.png", 1800, 1800)
print("### images: results/13_images/chip_full.png , chip_zoom.png")
