#!/usr/bin/env bash
# Reset the demo repo to its starter state. Usage: ./reset.sh YOUR_USERNAME
set -euo pipefail
[[ $# -eq 1 ]] || { echo "usage: $0 YOUR_GITHUB_USERNAME" >&2; exit 2; }

cd "$(dirname "$0")/../sales-pipeline-demo"
START_SHA=$(git rev-list --max-parents=0 HEAD)

git switch main
git branch -D feature/add-test 2>/dev/null || true
git push origin --delete feature/add-test 2>/dev/null || true
git reset --hard "$START_SHA"
git push --force origin main

echo
echo "Reset to $START_SHA"
echo "Now delete the branch protection rule:"
echo "  https://github.com/$1/sales-pipeline-demo/settings/branches"
