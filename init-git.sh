# Inicializa git, crea el primer commit y te guía para subirlo a GitHub

git init
git add .
git commit -m "Proyecto Smart Link - primer commit"

# Crea el repositorio en GitHub manualmente y luego ejecuta:
# Sustituye TU_USUARIO y TU_REPO por los tuyos
git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
git branch -M main
git push -u origin main
