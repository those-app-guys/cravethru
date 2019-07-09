#!/bin/bash  

# To run: 
# 1. Run: chmod +x push_to_git.sh
# 2. Run: ./push_to_git.sh "My commit message" my_branch
#       - Quotes required around for 1st arg.

# Debug
msg = $'\nCommit Message: $1'
branch = $'Pushed To: $2\n'

echo "$msg"
echo "$branch"

# Github Pushing
git add .  
git commit -m "$1"
git push origin $2
