#!/usr/bin/env python3
from Xlib import X, display
from Xlib.ext import shape

d = display.Display()
screen = d.screen()
root = screen.root

# --- geometry ---
W, H = 800, 600
OFFSET_X = 300 + 300   # offset via sum of variables
OFFSET_Y = 300 + 300

# --- color ---
COLOR = 0xFF0000       # frame color (red)

# --- create window ---
win = root.create_window(
    OFFSET_X, OFFSET_Y, W, H, 0,
    screen.root_depth,
    X.InputOutput,
    X.CopyFromParent,
    override_redirect=True,
    background_pixel=COLOR,
    event_mask=X.ExposureMask,
)
win.map()
d.flush()

# --- bounding shape: 4px frame ---
t = 4
bound_pm = win.create_pixmap(W, H, 1)
gc = bound_pm.create_gc(foreground=0, background=0)
bound_pm.fill_rectangle(gc, 0, 0, W, H)          # all "invisible"
gc.change(foreground=1)
bound_pm.fill_rectangle(gc, 0, 0, W, t)          # top
bound_pm.fill_rectangle(gc, 0, H - t, W, t)      # bottom
bound_pm.fill_rectangle(gc, 0, 0, t, H)          # left
bound_pm.fill_rectangle(gc, W - t, 0, t, H)      # right
win.shape_mask(shape.SO.Set, shape.SK.Bounding, 0, 0, bound_pm)
d.flush()

# --- input shape: empty mask -> clicks pass through ---
input_pm = win.create_pixmap(W, H, 1)
gc2 = input_pm.create_gc(foreground=0, background=0)
input_pm.fill_rectangle(gc2, 0, 0, W, H)         # all 0 -> no click capture
win.shape_mask(shape.SO.Set, shape.SK.Input, 0, 0, input_pm)
d.flush()

# --- event loop (keep window alive) ---
while True:
    ev = d.next_event()
    if ev.type == X.Expose:
        pass  # no redraw needed, background is set
