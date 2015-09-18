#!/bin/bash
# usage: ./make_install.sh --phone=10.0.1.2 -v

parts=("src/elm-module-preamble.js" "build/elm.js" "src/elm-module-postamble.js")
target=src/js/elm-module.js
src="src/elm/Watchface.elm src/elm/StartPebble.elm"

elm-make $src --output=build/elm.js || exit 1

echo '' > "$target"
for part in "${parts[@]}"; do
    cat "$part" >> "$target" || exit 1
done

echo "Successfully generated CommonJS/Node/AMD compatible module $target"

pebble clean && pebble build && pebble install $@
