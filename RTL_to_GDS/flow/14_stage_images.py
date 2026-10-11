# STEP 14 : one picture per physical-design stage (DEF + LEF rendered by KLayout, batch)
# run: klayout -b -r 14_stage_images.py
import os
import pya

res     = os.environ.get("RES", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "results"))
pdkpath = os.environ.get("PDKPATH", "/foss/pdks/sky130A")
scl     = f"{pdkpath}/libs.ref/sky130_fd_sc_hd"
lyp     = f"{pdkpath}/libs.tech/klayout/tech/sky130A.lyp"
layer_map = f"{pdkpath}/libs.tech/klayout/tech/sky130A.map"
out     = f"{res}/13_images"
os.makedirs(out, exist_ok=True)

for stage in ["04_floorplan", "05_pdn", "06_place", "07_cts", "08_route"]:
    opt = pya.LoadLayoutOptions()
    cfg = opt.lefdef_config
    cfg.lef_files = [f"{scl}/techlef/sky130_fd_sc_hd__nom.tlef", f"{scl}/lef/sky130_fd_sc_hd.lef"]
    cfg.map_file = layer_map
    cfg.macro_layout_files = [f"{scl}/gds/sky130_fd_sc_hd.gds"]   # real cell layouts
    for attr in ("produce_labels", "produce_lef_labels", "produce_pin_names",
                 "produce_obstructions", "produce_cell_outlines"):
        if hasattr(cfg, attr):
            setattr(cfg, attr, False)          # no row / cell name text, no blockages

    view = pya.LayoutView()
    view.load_layout(f"{res}/{stage}.def", opt, True)
    view.load_layer_props(lyp)
    view.max_hier()
    view.set_config("background-color", "#000000")
    view.set_config("grid-visible", "false")
    view.set_config("text-visible", "false")
    view.zoom_fit()
    view.save_image(f"{out}/stage_{stage}.png", 1000, 1000)
    print(f"### saved results/13_images/stage_{stage}.png")
