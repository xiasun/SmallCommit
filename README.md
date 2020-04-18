# SmallCommit
Commit and push all files with several small commits to avoid size limitation.

Use LFS if single files had already exceeds the size limitation of git server.

## Features
When initialize a project we may need to commit and push a large amount of files. The size of single push might exceeds the limination of git servers. This tiny script is coded to iterate through the entire git repo, and commit files when a size limitation is reached.

1. `.gitignore` is supposed to be filled before running this script;
2. this script will iterate through all untracked files in a git repo and count their size, a commit/push pairing opperation will be conducted when a certain size (100MB by default) is reached;
3. Size limitation and commit message can be specified, commit messages will be like xxx 0, xxx 1, xxx 2...

## Usages
Move `small-commit.sh` script to the root of your repo and run it.

## Known issues
1. Non-ascii characters and spaces in file path do not work in some cases;
