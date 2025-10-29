# Frequently Asked Questions (FAQ)

## Merging Branches with Different Commit Histories

### Q: Why do my branches have different commit histories?

**A:** Branches can have different (unrelated) commit histories when:
1. They were created independently (not branched from each other)
2. One branch was initialized separately
3. The repository had separate initialization for different branches
4. Someone force-pushed and rewrote history

In this repository, `main` and `dev` were created independently with different initial commits.

### Q: Is it safe to merge branches with different histories?

**A:** Yes, it's safe when you understand what you're doing. The `--allow-unrelated-histories` flag is designed for this purpose. However:
- **DO** review all changes carefully
- **DO** create a backup branch before merging
- **DO** communicate with your team
- **DO** test thoroughly after merging
- **DON'T** blindly merge without understanding the content

### Q: What will happen to my files after the merge?

**A:** The merge will combine files from both branches:
- Files that exist only in `main` will remain
- Files that exist only in `dev` will be added
- Files that exist in both branches will need to be merged (may cause conflicts)

### Q: How do I handle conflicts?

**A:** When conflicts occur:
1. Git will mark the conflicting files
2. Open each file and look for conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. Edit the file to keep the content you want (or combine both)
4. Remove the conflict markers
5. Stage the resolved file: `git add <file>`
6. Complete the merge: `git commit`

See the [MERGE_GUIDE.md](MERGE_GUIDE.md) for detailed instructions.

### Q: What if I make a mistake during the merge?

**A:** You have several options:

**If merge is in progress (not committed yet):**
```bash
git merge --abort
```

**If merge is committed but not pushed:**
```bash
git reset --hard HEAD~1
```

**If merge is already pushed:**
```bash
# Revert the merge (creates a new commit that undoes the merge)
git revert -m 1 <merge-commit-hash>
git push origin main
```

The automated script (`merge-dev-to-main.sh`) creates a backup branch automatically.

### Q: Can I use rebase instead of merge?

**A:** Rebase is **not recommended** for unrelated histories because:
- Rebase tries to replay commits on top of another branch
- Without a common ancestor, this doesn't work well
- It can create a confusing history
- Merge is the appropriate tool for combining unrelated histories

### Q: Will this affect my dev branch?

**A:** No, the merge only affects the target branch (main). Your dev branch will remain unchanged. After the merge, you have several options:
1. Keep both branches separate
2. Delete the dev branch if it's no longer needed
3. Continue using dev and merge changes as needed

### Q: Should I delete the dev branch after merging?

**A:** It depends on your workflow:
- **Keep it** if you want to continue development in the dev branch
- **Delete it** if the dev branch was a one-time setup and you're consolidating to main
- **Ask your team** about the branching strategy

### Q: How do I verify the merge was successful?

**A:** After merging:
1. Check the commit history: `git log --oneline --graph --all -10`
2. List all files: `ls -la`
3. Verify specific files: `cat <filename>`
4. Run your tests if available
5. Check that all expected files are present

### Q: What's the difference between merge and cherry-pick?

**A:** 
- **Merge**: Combines all changes from one branch to another, preserving history
- **Cherry-pick**: Selects specific commits to apply to another branch

Use merge for combining entire branches, cherry-pick for selective commits.

### Q: Can I merge main into dev instead?

**A:** Yes! The process is the same, just swap the branches:
```bash
git checkout dev
git merge main --allow-unrelated-histories
```

The question is which branch should be your "source of truth" going forward.

### Q: What if I get "fatal: refusing to merge unrelated histories"?

**A:** This is expected! It means Git detected that the branches have no common ancestor. Simply add the `--allow-unrelated-histories` flag:
```bash
git merge dev --allow-unrelated-histories
```

### Q: How often should I merge between branches?

**A:** Best practices suggest:
- Merge frequently to avoid large conflicts
- Merge after completing features
- Merge before starting new work on a branch
- Establish a regular merge schedule with your team

However, for this specific case of merging unrelated histories, it's typically a one-time operation.

### Q: Will this create a messy commit history?

**A:** The merge commit will have two parent commits from different histories, which might look unusual in the git log, but:
- It accurately represents what happened
- It's better than rewriting history
- Future commits will have a normal linear history
- Tools like `git log --graph` visualize it clearly

### Q: What files are currently different between main and dev?

**A:** Based on the current state:

**Main branch has:**
- `.gitignore`
- `LICENSE`
- `README.md` (brief, 292 bytes)

**Dev branch has:**
- `README.md` (detailed, 3219 bytes)

**Expected conflict:** README.md (different content)

### Q: Can I preview what the merge will look like?

**A:** Yes! Use these commands:
```bash
# See which files differ
git diff --name-status main dev

# See the actual differences
git diff main dev

# See just the README difference
git diff main dev -- README.md
```

### Q: Is there a GUI tool for this?

**A:** Yes, several Git GUI tools support merging with conflict resolution:
- GitKraken
- SourceTree
- GitHub Desktop
- Git GUI (built-in)
- VS Code's Git integration
- IntelliJ IDEA / other JetBrains IDEs

Most of these will detect the unrelated histories and prompt you accordingly.

### Q: What should I do after the merge?

**A:** Recommended next steps:
1. Review all files in the merged branch
2. Run tests (if available)
3. Update documentation if needed
4. Communicate the merge to your team
5. Decide on a branching strategy going forward
6. Clean up any backup branches (after confirming merge is good)

### Q: Where can I learn more?

**A:** Check these resources:
- [QUICK_MERGE_REFERENCE.md](QUICK_MERGE_REFERENCE.md) - Quick commands
- [MERGE_GUIDE.md](MERGE_GUIDE.md) - Comprehensive guide
- [BRANCH_VISUALIZATION.md](BRANCH_VISUALIZATION.md) - Visual explanations
- [Official Git Documentation](https://git-scm.com/docs/git-merge)
- [Pro Git Book](https://git-scm.com/book/en/v2)
