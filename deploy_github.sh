#!/bin/bash
# Build Flutter web app
flutter build web --release --web-renderer canvaskit

# Create gh-pages branch if it doesn't exist
git checkout -b gh-pages || git checkout gh-pages

# Copy build files
cp -r build/web/* .

# Commit and push
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages --force

# Return to main branch
git checkout main
