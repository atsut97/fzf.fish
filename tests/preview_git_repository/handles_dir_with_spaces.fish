# Make a temporary repository
set --local repo 'tests/_resources/repo with spaces'
rm -rf "$repo"
mkdir -p "$repo"
git init --quiet "$repo"

# Remove ANSI color codes
mock bat "--style=numbers --color=always" "cat \$argv"

set contents "# Spaced Repository"
echo "$contents" >"$repo/README.md"
set actual (_fzf_preview_git_repository "$repo")

@test "correctly handles directory paths with spaces" "$actual" = "$contents"

rm -rf "$repo"
