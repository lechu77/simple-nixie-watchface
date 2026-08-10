# SIMPLE NIXIE WATCHFACE

This is a premium Garmin Connect IQ watch face centered purely around Nixie tube aesthetics.

## Design principles

- **Absolute focus on visuals**: The Nixie tubes are the absolute protagonist. Big, high-res, glowing digits.
- **Minimalism & Cleanliness**: Features battery, date, and two bottom graphs (health metrics). All widgets can be toggled off to leave a 100% clean Nixie display.
- **Authenticity**: Maximize the gas-discharge glow effect, using high-resolution bitmaps and proper placement.
- **Always-On Display (AOD)**: Implements burn-in protection via pixel shifting and strictly hides all background and widgets when entering low-power mode, leaving only the Nixie digits.

## Architecture & Rendering

- Inherited knowledge from `REACTOR`: zero-allocation draw loop, heavily cached bitmaps.
- Battery-friendly rendering despite large bitmaps.
- Clear separation between data providers, widgets, and view.
- Single responsibility classes, readable code.
- Uses `Menu2` for an on-device settings menu (`getSettingsView`), and respects Garmin's multi-language folder structure (`resources-eng`, `resources-spa`).
