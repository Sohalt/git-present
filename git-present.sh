#!/usr/bin/env zsh
#set -eo pipefail
repo="$1"
workdir=$(mktemp -d)
commits_file=$(mktemp)
git clone "$repo" "$workdir"
cd "$workdir"
commits=$(git log --format=format:%H | cat - <(echo "") | tac)
echo "$commits" > "$commits_file"
initial_commit=$(head -n 1 "$commits_file")
git checkout -b present "$initial_commit"

next (){
    commit=$(head -n 1 "$commits_file")
    rest=$(tail -n+2 "$commits_file")
    echo "$rest" > "$commits_file"
    git cherry-pick --no-commit "$commit"
    message="$(git log --format=format:%B -n 1 "$commit")"
    git diff --staged
    print -z "git commit -a -m \"${message}\""
}
