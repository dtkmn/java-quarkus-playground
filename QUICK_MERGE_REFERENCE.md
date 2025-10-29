# Quick Reference: Merging dev to main

## One-Line Solution

```bash
git checkout main && git merge dev --allow-unrelated-histories
```

## Step-by-Step Commands

```bash
# 1. Switch to main branch
git checkout main

# 2. Merge dev branch (allowing unrelated histories)
git merge dev --allow-unrelated-histories

# 3. If conflicts occur, resolve them and complete the merge
git add .
git commit -m "Merge dev into main"

# 4. Push the changes
git push origin main
```

## Using the Automated Script

We've provided a helper script that automates this process with safety checks:

```bash
./merge-dev-to-main.sh
```

The script will:
- Check for uncommitted changes
- Create a backup branch
- Perform the merge with appropriate flags
- Guide you through conflict resolution if needed

## Common Scenarios

### Scenario 1: No Conflicts
If there are no conflicting files, Git will automatically create a merge commit.

### Scenario 2: README.md Conflict
Both branches have README.md with different content:
- **main**: Brief project description
- **dev**: Detailed Quarkus setup instructions

**Recommended Resolution:**
Combine both contents - keep the description from main at the top, followed by detailed instructions from dev.

### Scenario 3: Merge Goes Wrong
If you need to undo the merge before pushing:

```bash
git merge --abort  # If merge is in progress
git reset --hard HEAD~1  # If merge is committed but not pushed
```

## For More Information

See [MERGE_GUIDE.md](MERGE_GUIDE.md) for detailed explanations and troubleshooting.
