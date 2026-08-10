# Developer Memory & Decisions

This file records hard-won lessons, quirks, and decisions that are easy to forget.

## Inherited Wisdom (from REACTOR)

### Simulator & Build Quirks
- **Settings persistence:** The simulator caches settings in a binary `*.SET` file under `$TMPDIR/com.garmin.connectiq/GARMIN/APPS/SETTINGS/`. 
- **CRITICAL MAC CACHE NAME:** Connect IQ on macOS saves the `.SET` file with the full name `SIMPLE-NIXIE.SET`, **not** the 8.3 `SIMPLE~1.SET` like in some Windows environments! If you try to clear the cache via bash scripts, make sure to target the correct filename.
- Changing defaults in `properties.xml` and recompiling does NOT override the cached values. You must delete the SET file.
- **Clean builds:** When changing `settings.xml`, `properties.xml`, or `drawables.xml`, always delete `bin/` and `gen/` before rebuilding to clear stale generated code.
- **Null Properties:** `Application.Properties.getValue("key")` will return `null` if the cache is uninitialized or dirty. Always use a ternary fallback (`var x = (val != null) ? val as Boolean : true`) before casting to avoid silent failures in `onUpdate`.

### Rendering Decisions
- **Zero Allocations:** No `new` objects should be created during `onUpdate()`.
- **AOD Implementation:** Backgrounds and thick widgets violate AOD 10% pixel limits. Hide them in `if (_isAod)` and apply a random offset `(clockTime.min % X)` to the remaining items for burn-in protection.
