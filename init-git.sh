# Inicializa git, crea el primer commit y te guía para subirlo a GitHub

git init
git add .
git commit -m "Proyecto Smart Link - primer commit"

# Crea el repositorio en GitHub manualmente y luego ejecuta:
# Sustituye TU_USUARIO y TU_REPO por los tuyos
git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
git branch -M main
git push -u origin main

# Si ves el error "Updates were rejected because the remote contains work that you do not have locally"
# Ejecuta estos comandos para traer los cambios remotos y fusionar:

git pull origin main --rebase

# Si no hay conflictos, vuelve a intentar el push:
git push -u origin main

# Si hay conflictos, resuélvelos, haz commit y luego:
# git push -u origin main
