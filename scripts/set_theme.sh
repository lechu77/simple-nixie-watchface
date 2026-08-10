#!/usr/bin/env bash

# SIMPLE NIXIE Theme Switcher
# Uso: ./scripts/set_theme.sh 0

THEME=$1

if [[ -z "$THEME" ]]; then
    echo ""
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║      SIMPLE NIXIE · Theme Switcher       ║"
    echo "  ╠══════════════════════════════════════════╣"
    echo "  ║  Uso: ./scripts/set_theme.sh <número>    ║"
    echo "  ╠══════════════════════════════════════════╣"
    echo "  ║  0 = Nixie (Default)                     ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo ""
    exit 0
fi

if [[ "$THEME" -ne 0 ]]; then
    echo "Error: por ahora solo se soporta el tema 0."
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROPERTIES_FILE="$PROJECT_ROOT/resources/settings/properties.xml"

# 1. Cambiar el valor por defecto en properties.xml
sed -i '' -E 's/<property id="themeStyle" type="number">[0-9]+<\/property>/<property id="themeStyle" type="number">'"$THEME"'<\/property>/' "$PROPERTIES_FILE"
echo "✓ properties.xml → themeStyle = $THEME"

# 2. Borrar la caché de settings del simulador
SIM_SETTINGS=$(find "$TMPDIR" -name "SIMPLE-NIXIE.SET" -o -name "SIMPLE~1.SET" 2>/dev/null)
if [[ -n "$SIM_SETTINGS" ]]; then
    rm -f "$SIM_SETTINGS"
    echo "✓ Caché del simulador eliminada ($SIM_SETTINGS)"
else
    echo "· No se encontró caché del simulador (SIMPLE~1.SET)"
fi

# 3. Borrar bin y gen para evitar errores de compilación por caché sucia
rm -rf "$PROJECT_ROOT/bin" "$PROJECT_ROOT/gen"

# 4. Recompilar y relanzar
echo "⟳ Recompilando..."
"$PROJECT_ROOT/scripts/build.sh"
echo "⟳ Lanzando simulador..."
"$PROJECT_ROOT/scripts/sim.sh"
