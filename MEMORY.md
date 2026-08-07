# Developer Memory & Decisions

This file records hard-won lessons, quirks, and decisions that are easy to forget.

## Inherited Wisdom (from REACTOR)

### Simulator & Build Quirks
- **Settings persistence:** The simulator caches settings in a binary `*.SET` file under `$TMPDIR/com.garmin.connectiq/GARMIN/APPS/SETTINGS/`. Changing defaults in `properties.xml` and recompiling does NOT override the cached values. You must delete the SET file.
- **Clean builds:** When changing `settings.xml`, `properties.xml`, or `drawables.xml`, always delete `bin/` and `gen/` before rebuilding to clear stale generated code.
- **OneDrive Dataless Files Lock:** macOS OneDrive can randomly lock `.png` files during compilation.

### Rendering Decisions
- **Zero Allocations:** No `new` objects should be created during `onUpdate()`.
- **Memory Management:** Large Nixie bitmaps must be loaded once on first draw and cached in arrays or dictionaries to keep memory usage stable and low.
- **Background:** Always clear the DC with pure black for optimal AMOLED power efficiency.
