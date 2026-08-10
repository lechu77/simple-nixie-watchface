# Project Context: Simple Nixie Watchface

A minimalist, high-impact Garmin Connect IQ watchface focusing solely on beautiful Nixie tube digits.

**Target:** High-res AMOLED Garmin watches (e.g., Fenix 8, Epix 2).

## Core Requirements & Features
- Massive, highly detailed Nixie tube digits dominating the screen.
- True gas-discharge glow aesthetic with a 3D depth illusion.
- Avoid all visual clutter. The watchface should look like a piece of vintage hardware.
- Optional Widgets: Battery level, Date (with pills layout), and two bottom graphs (Heart Rate, Elevation, etc.). All configurable.
- Settings accessible via both Connect IQ Mobile App (`properties.xml`/`settings.xml`) and directly on-device (`Menu2` implementation).
- AOD (Always-On Display) support with burn-in prevention pixel shifting.
- Multi-language support (English and Spanish out of the box).

## Architecture Guidelines
- Build upon the solid foundation learned from the `REACTOR` project.
- **Zero-allocation draw loops**: Never allocate new objects in `onUpdate()`.
- **Bitmap Caching**: Load Nixie bitmaps once during initialization or lazily, and reuse them.
- **Safe Properties**: Always perform null checks and provide fallbacks when reading `Application.Properties` to avoid crashes on dirty caches.

## File Structure Overview
- `source/SimpleNixieApp.mc`: App base, provides Settings View.
- `source/SimpleNixieView.mc`: Main rendering loop, handles AOD offsets and widget toggles.
- `source/SimpleNixieSettingsMenu.mc`: On-device settings menu (`Menu2`).
- `resources/`, `resources-eng/`, `resources-spa/`: Language files and settings configuration.
