#!/bin/bash
# usage: ./make_install.sh --phone=10.0.1.2 -v

parts=("src/js/elm-module-preamble.js" "build/elm.js" "src/js/elm-module-postamble.js")
target=build/src/js/elm-module.js

elm-make src/elm/App.elm --output=build/elm.js || exit 1

echo '' > "$target"
for part in "${parts[@]}"; do
    cat "$part" >> "$target" || exit 1
done

echo "Successfully generated CommonJS/Node/AMD compatible module $target"

pebble clean && pebble build && pebble install $@
