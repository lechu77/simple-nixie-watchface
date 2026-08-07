# Project Context: Simple Nixie Watchface

A minimalist, high-impact Garmin Connect IQ watchface focusing solely on beautiful Nixie tube digits.

**Target:** High-res AMOLED Garmin watches (e.g., Fenix 8, Epix 2).

## Core Requirements
- Display only Time (Hours, Minutes) and Battery level.
- Massive, highly detailed Nixie tube digits dominating the screen.
- True gas-discharge glow aesthetic.
- Avoid all visual clutter. The watchface should look like a piece of vintage hardware.

## Architecture Guidelines
- Build upon the solid foundation learned from the `REACTOR` project.
- **Zero-allocation draw loops**: Never allocate new objects in `onUpdate()`.
- **Bitmap Caching**: Load Nixie bitmaps once during initialization or lazily, and reuse them.
- Maintain a pure AMOLED black `#000000` background to minimize battery drain.

## File Structure
*To be populated as development progresses.*
