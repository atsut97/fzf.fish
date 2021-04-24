# Create a mock repository that excludes README
set mock_repo (mktemp -d)
git init --quiet $mock_repo
mock fd \* "return 0"
mock ls \* "echo file.txt"

set actual (__fzf_preview_git_repository $mock_repo readme)
@test "lists contents of repository instead when no README found" "$actual" = "file.txt"

rm -rf $mock_repo
