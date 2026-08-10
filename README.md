# Simple Nixie Watchface 🕰️

A premium, minimalist **Garmin Connect IQ** watch face focused entirely on the beautiful gas-discharge glow aesthetic of Nixie tubes. Built for high-res AMOLED displays (like Fenix 8, Epix 2), this watch face mimics vintage hardware with a stunning illusion of 3D depth.

## Features ✨

- **Absolute Focus on Visuals**: Massive, highly detailed Nixie tube digits dominate the screen.
- **Battery-Friendly Rendering**: Heavily cached bitmaps and zero-allocation draw loops ensure smooth performance and low battery consumption.
- **Always-On Display (AOD)**: Full AMOLED burn-in protection via pixel shifting. In low-power mode, the UI elegantly strips away the background and widgets, leaving only the glowing Nixie filaments.
- **Configurable Widgets**: Includes optional Battery, Date, and Health Metrics (Heart Rate, Elevation, etc.). All widgets can be toggled off for a 100% clean Nixie display.
- **On-Device Settings**: Fully integrates with Garmin's `Menu2` system, allowing you to configure the watch face directly from your wrist or via the Connect IQ mobile app.
- **Multi-Language**: Out-of-the-box support for English and Spanish.

## Architecture & Codebase 🏗️

This project embraces modern "vibecoding" and AI-assisted development. It inherits rendering patterns from the `REACTOR` project, enforcing strict Garmin best practices:
- **Zero-Allocation**: No `new` objects are created inside the `onUpdate()` draw loop.
- **Safe Properties**: Implements resilient `Application.Properties` parsing to prevent crashes on dirty caches.

> **Note for Contributors:** Please read `AGENTS.md`, `CONTEXT.md`, and `MEMORY.md` before contributing. These files contain essential context, design principles, and simulator quirks specifically documented for AI assistants and developers.

## Building and Running 🚀

1. Ensure you have the [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) installed.
2. Clone this repository.
3. Use the provided shell scripts (macOS/Linux) to easily build and simulate the project:

```bash
# Build the project
./scripts/build.sh

# Run the simulator
./scripts/sim.sh

# Reset simulator cache and load the default theme
./scripts/set_theme.sh 0
```

## Contributing 🤝

Since this is an Open Source (FOSS) project, contributions are highly welcome! Feel free to open issues, submit pull requests, or fork the project to add your own features (like seconds, moon phases, or new data fields).

## License 📄

This project is open-source and available for the Garmin developer community.
