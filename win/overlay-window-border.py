#!/usr/bin/env python3
import argparse
import sys
import threading
import time
import os
from Xlib import X, display
from Xlib.ext import shape

def parse_args():
    parser = argparse.ArgumentParser(
        description="Draw a click-through frame on X11.",
        usage="%(prog)s COLOR X1 Y1 X2 Y2 [--timeout MS] [--border-width PX]",
                formatter_class=argparse.RawDescriptionHelpFormatter,   
        epilog=(                                                 
            "examples:\n"
            "  %(prog)s 0xFF0000 600 600 1400 1200\n"
            "  %(prog)s 0x00FF00 100 100 500 400 --border-width 2 --timeout 3000\n"
        ),
    )
    parser.add_argument("color", type=lambda s: int(s, 0),
                        help="frame color (hex or decimal), e.g. 0xFF0000")
    parser.add_argument("x1", type=int, help="left edge X")
    parser.add_argument("y1", type=int, help="top edge Y")
    parser.add_argument("x2", type=int, help="right edge X")
    parser.add_argument("y2", type=int, help="bottom edge Y")
    parser.add_argument("--timeout", type=int, default=0,
                        help="auto-close after N milliseconds (0 = stay forever)")
    parser.add_argument("--border-width", type=int, default=4,
                        help="frame thickness in pixels (default 4)")
    return parser.parse_args()

def main():
    if len(sys.argv) == 1:
        parse_args()  # prints help and exits
        return

    args = parse_args()

    # normalize coordinates so x1<x2, y1<y2
    x1, x2 = sorted((args.x1, args.x2))
    y1, y2 = sorted((args.y1, args.y2))

    W = x2 - x1
    H = y2 - y1
    if W <= 0 or H <= 0:
        print("error: zero-size frame", file=sys.stderr)
        sys.exit(1)

    t = args.border_width
    COLOR = args.color

    d = display.Display()
    screen = d.screen()
    root = screen.root

    win = root.create_window(
        x1, y1, W, H, 0,
        screen.root_depth,
        X.InputOutput,
        X.CopyFromParent,
        override_redirect=True,
        background_pixel=COLOR,
        event_mask=X.ExposureMask,
    )
    win.map()
    d.flush()

    # --- bounding shape: frame of thickness t ---
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

    # --- timeout: auto-close after N ms ---
    if args.timeout > 0:
        def close_later():
            time.sleep(args.timeout / 1000.0)
            try:
                win.destroy()
                d.flush()
            except Exception:
                pass
            finally:
                os._exit(0)
        threading.Thread(target=close_later, daemon=True).start()

    # --- event loop (keep window alive) ---
    while True:
        try:
            ev = d.next_event()
            if ev.type == X.Expose:
                pass  # no redraw needed, background is set
        except Exception:
            break

if __name__ == "__main__":
    main()
