#!/usr/bin/env bash
set -euo pipefail

message="${*:-Actualización de CarWash}"

echo "1/4 Validando la aplicación…"
npm test

echo "2/4 Preparando los cambios…"
git add .

if git diff --cached --quiet; then
  echo "No hay cambios nuevos para publicar."
  exit 0
fi

echo "3/4 Guardando la actualización…"
git commit -m "$message"

echo "4/4 Sincronizando con GitHub…"
git pull --rebase origin main
git push origin main

echo "Actualización publicada en GitHub. Ya puedes desplegarla manualmente en Render."
