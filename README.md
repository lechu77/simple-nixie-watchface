# Simple Nixie Watchface 🕰️

**Simple Nixie** is a premium Garmin Connect IQ watch face focused entirely on the beautiful gas-discharge glow aesthetic of Nixie tubes. Built for high-res AMOLED displays (like Fenix 8, Epix 2), this watch face mimics vintage hardware with a stunning illusion of 3D depth, while keeping a minimalist and battery-friendly profile.

## Features

- **Absolute Focus on Visuals**: Massive, highly detailed Nixie tube digits dominate the screen.
- **6 Two-Tone Color Themes**: Switch between Nixie Amber (Default), Cyan, Green, Amber, White, and Siemens Blue. Auxiliary widgets change color while the tubes keep their authentic gas glow.
- **Configurable Widgets**: Includes optional Battery, Date, and Dual Health Metrics (Heart Rate, Elevation, etc.). All widgets can be toggled off for a 100% clean Nixie display.
- **Always-On Display (AOD)**: Full AMOLED burn-in protection via pixel shifting. In low-power mode, the UI elegantly strips away the background and widgets, leaving only the glowing Nixie filaments.
- **On-Device Settings**: Fully integrates with Garmin's `Menu2` system, allowing you to configure the watch face directly from your wrist or via the Connect IQ mobile app.
- **Multi-Language**: Out-of-the-box support for English and Spanish.
- **Battery-Friendly Rendering**: Heavily cached bitmaps and zero-allocation draw loops ensure smooth performance.

## Device Support

| Device | Status |
|---|---|
| Garmin Fenix 8 AMOLED (47mm) | ✅ Primary target |
| Garmin Epix Gen 2 / Pro | 🔄 Secondary |
| Garmin Enduro 3 | 🔄 Secondary |
| Garmin Tactix 8 AMOLED | 🔄 Secondary |

## Requirements

- **Connect IQ SDK** ≥ 9.2 ([Download](https://developer.garmin.com/connect-iq/sdk/))
- **macOS** (build scripts use bash/zsh)
- A Garmin AMOLED device or the Connect IQ Simulator

## Building & Running

### 1. Clone the repo

```bash
git clone https://github.com/Lechu77/simple-nixie-watchface.git
cd simple-nixie-watchface
```

### 2. Build

```bash
./scripts/build.sh
```

This compiles the project using `monkeyc` from your installed SDK and outputs `bin/simple-nixie.prg`.

### 3. Run in the Simulator

```bash
./scripts/sim.sh
```

This starts the Connect IQ Simulator (if not already running) and loads the watchface for the Fenix 8 (47mm).

### 4. Switch Themes (Cache Clear)

```bash
./scripts/set_theme.sh 0
```
This resets the simulator cache (deleting the `.SET` file) and launches the default theme.

## Installing on a Physical Watch

### Option A: Sideload via USB (Development)

Note: Recent macOS versions (including macOS 26) do not mount MTP devices as regular filesystems under `/Volumes`. Use a dedicated MTP tool (for example OpenMTP) to transfer the `.prg` file if your watch doesn't appear in Finder.

1. Build the `.prg` file:
   ```bash
   ./scripts/build.sh
   ```
2. Transfer the binary to the watch using one of these methods:
   - If the device mounts as a mass-storage volume (older models / Windows): copy to the device `GARMIN/APPS/` folder, e.g.
    ```bash
    cp bin/simple-nixie.prg /Volumes/<DEVICE_NAME>/GARMIN/APPS/
    ```
   - If macOS does not mount it (macOS 26+), use OpenMTP (or another MTP client) to copy `bin/simple-nixie.prg` into the watch filesystem (place in the APPS or GARMIN/APPS folder as shown by the client).

3. Safely disconnect (use the app's disconnect or eject the device) and unplug the cable.
4. On the watch: Settings → Watch Face → select **Simple Nixie**.

### Option B: Connect IQ Store (Distribution)

1. Create a developer account at [developer.garmin.com](https://developer.garmin.com).
2. Package the app (release .iq signed with your developer key):
   ```bash
   monkeyc -f monkey.jungle -o bin/simple-nixie.iq -e -y developer_key.der -r
   ```
   The signed package will be created at `bin/simple-nixie.iq`.
3. Upload the `.iq` file to the Connect IQ Store.

## Project Structure

This project embraces modern "vibecoding" and AI-assisted development. It inherits rendering patterns from the `REACTOR` project.

> **Note for Contributors:** Please read `AGENTS.md`, `CONTEXT.md`, and `MEMORY.md` before contributing. These files contain essential context, design principles, and simulator quirks specifically documented for AI assistants and developers.

```
simple-nixie-watchface/
├── source/
│   ├── SimpleNixieApp.mc          # App entry point
│   ├── SimpleNixieView.mc         # Main view & widget orchestrator
│   └── SimpleNixieSettingsMenu.mc # On-device Settings menu
├── resources/
│   ├── drawables/                 # Bitmap assets (Nixie tubes, Background)
│   ├── settings/                  # properties.xml & settings.xml
│   └── strings/                   # UI string labels (multi-language)
├── resources-eng/                 # English translations
├── resources-spa/                 # Spanish translations
├── scripts/
│   ├── build.sh                   # Compile the project
│   ├── sim.sh                     # Launch in simulator
│   └── set_theme.sh               # Utility to clear cache
├── manifest.xml                   # App manifest (devices, permissions)
└── monkey.jungle                  # Build configuration
```

## License

See [LICENSE](LICENSE) for details.
