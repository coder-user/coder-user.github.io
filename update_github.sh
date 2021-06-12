#!/bin/bash
hugo --gc --minify -e production -d docs --baseUrl="https://coder-user.github.io/"
git add *
git commit -m "$1"
git push