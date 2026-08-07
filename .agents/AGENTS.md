# SIMPLE NIXIE WATCHFACE

This is a premium Garmin Connect IQ watch face centered purely around Nixie tube aesthetics.

## Design principles

- **Absolute focus on visuals**: The Nixie tubes are the absolute protagonist. Big, high-res, glowing digits.
- **Minimalism**: Only show the battery widget and the clock widget (hours and minutes). No clutter, no extra metrics unless explicitly requested later.
- **Authenticity**: Maximize the gas-discharge glow effect, using high-resolution bitmaps and proper placement.

## Architecture & Rendering

- Inherited knowledge from `REACTOR`: zero-allocation draw loop, heavily cached bitmaps.
- Battery-friendly rendering despite large bitmaps.
- Clear separation between data providers, widgets, and view.
- Single responsibility classes, readable code.
