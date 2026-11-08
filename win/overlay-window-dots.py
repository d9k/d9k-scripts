#!/usr/bin/env python3
import argparse
import json
import sys
import threading
import time
import os
from Xlib import X, display
from Xlib.ext import shape

def parse_args():
    parser = argparse.ArgumentParser(
        description="Draw dots overlay on X11.",
        usage="%(prog)s [--help] JSON_POINTS [--radius PX] [--color HEX] [--timeout MS]",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "examples:\n"
            "  %(prog)s '[{\"x\":400,\"y\":300}]'\n"
            "\n"
            "  JSON_POINTS='[{\"x\":400,\"y\":300},{\"x\":800,\"y\":600},{\"x\":1200,\"y\":200}]';\n    %(prog)s \"$JSON_POINTS\" --radius 10 --color 0x00FF00 --timeout 3000\n"
        ),
    )
    parser.add_argument("json_points", metavar="JSON_POINTS",
                        help='JSON array of points, e.g. [{"x":45,"y":12}]')
    parser.add_argument("--radius", type=int, default=5,
                        help="dot radius in pixels (default 5)")
    parser.add_argument("--color", type=lambda s: int(s, 0), default=0xFF0000,
                        help="dot color (hex or decimal), e.g. 0xFF0000")
    parser.add_argument("--timeout", type=int, default=0,
                        help="auto-close after N milliseconds (0 = stay forever)")

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)

    return parser.parse_args()

def load_points(raw_json):
    try:
        points = json.loads(raw_json)
    except json.JSONDecodeError as e:
        print("error: invalid JSON points:", e, file=sys.stderr)
        sys.exit(1)

    if not isinstance(points, list) or not points:
        print("error: JSON points must be a non-empty array", file=sys.stderr)
        sys.exit(1)

    for point in points:
        if not isinstance(point, dict) or "x" not in point or "y" not in point:
            print("error: each point must have numeric x and y", file=sys.stderr)
            sys.exit(1)

    return points

def main():
    args = parse_args()
    points = load_points(args.json_points)

    d = display.Display()
    screen = d.screen()
    root = screen.root

    wins = []
    for point in points:
        x, y = int(point["x"]), int(point["y"])
        r = args.radius
        size = 2 * r

        win = root.create_window(
            x - r, y - r, size, size, 0,
            screen.root_depth,
            X.InputOutput,
            X.CopyFromParent,
            override_redirect=True,
            background_pixel=args.color,
        )

        # --- bounding shape: visible circle only, so square corners stay transparent ---
        bound_pm = win.create_pixmap(size, size, 1)
        gc = bound_pm.create_gc(foreground=0, background=0)
        bound_pm.fill_rectangle(gc, 0, 0, size, size)               # all "invisible"
        gc.change(foreground=1)
        # Arc tuple is (x, y, width, height, angle1, angle2); angles in 1/64 of a degree
        bound_pm.poly_fill_arc(gc, [(0, 0, size, size, 0, 360 * 64)])   # circle becomes visible
        win.shape_mask(shape.SO.Set, shape.SK.Bounding, 0, 0, bound_pm)

        # --- input shape: empty mask -> clicks pass through ---
        input_pm = win.create_pixmap(size, size, 1)
        gc2 = input_pm.create_gc(foreground=0, background=0)
        input_pm.fill_rectangle(gc2, 0, 0, size, size)              # all 0 -> no click capture
        win.shape_mask(shape.SO.Set, shape.SK.Input, 0, 0, input_pm)

        win.map()
        wins.append(win)

    d.flush()

    # --- timeout: auto-close after N ms ---
    if args.timeout > 0:
        def close_later():
            time.sleep(args.timeout / 1000.0)
            for win in wins:
                try:
                    win.destroy()
                except Exception:
                    pass
            try:
                d.flush()
            except Exception:
                pass
            os._exit(0)
        threading.Thread(target=close_later, daemon=True).start()

    # --- event loop (keep windows alive) ---
    while True:
        try:
            d.next_event()
        except Exception:
            break

if __name__ == "__main__":
    main()
