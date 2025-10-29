#!/bin/bash

# Script to merge dev branch into main branch when they have different commit histories
# This script demonstrates the process and includes safety checks

set -e  # Exit on error

echo "=========================================="
echo "Merging dev into main (Unrelated Histories)"
echo "=========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository!"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    print_warning "You have uncommitted changes. Please commit or stash them first."
    echo ""
    git status --short
    echo ""
    read -p "Do you want to stash these changes? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Stashing changes..."
        git stash
    else
        print_error "Please handle uncommitted changes before continuing."
        exit 1
    fi
fi

# Fetch latest changes
print_info "Fetching latest changes from remote..."
git fetch origin

# Check if main branch exists
if ! git show-ref --verify --quiet refs/heads/main; then
    print_info "Creating local main branch from origin/main..."
    git checkout -b main origin/main
else
    print_info "Switching to main branch..."
    git checkout main
    
    # Update main to match remote
    print_info "Updating main branch from remote..."
    git pull origin main || print_warning "Could not pull from origin/main (might not exist or have diverged)"
fi

# Check if dev branch exists
if ! git show-ref --verify --quiet refs/heads/dev; then
    if git show-ref --verify --quiet refs/remotes/origin/dev; then
        print_info "Creating local dev branch from origin/dev..."
        git checkout -b dev origin/dev
        git checkout main
    else
        print_error "Dev branch does not exist locally or remotely!"
        exit 1
    fi
fi

# Check if branches have a common ancestor
print_info "Checking if branches have a common ancestor..."
if git merge-base main dev > /dev/null 2>&1; then
    print_info "Branches share a common ancestor. Standard merge can be used."
    MERGE_CMD="git merge dev"
else
    print_warning "Branches have unrelated histories. Will use --allow-unrelated-histories flag."
    MERGE_CMD="git merge dev --allow-unrelated-histories"
fi

# Show what files will be affected
print_info "Files in main branch:"
git ls-tree -r --name-only main | head -10
echo ""

print_info "Files in dev branch:"
git ls-tree -r --name-only dev | head -10
echo ""

# Create a backup branch
BACKUP_BRANCH="main-backup-$(date +%Y%m%d-%H%M%S)"
print_info "Creating backup branch: $BACKUP_BRANCH"
git branch $BACKUP_BRANCH main

# Confirm before proceeding
echo ""
print_warning "About to merge dev into main using: $MERGE_CMD"
print_info "A backup branch has been created: $BACKUP_BRANCH"
echo ""
read -p "Do you want to proceed with the merge? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Merge cancelled by user."
    exit 0
fi

# Perform the merge
print_info "Executing merge..."
if eval $MERGE_CMD; then
    print_info "Merge completed successfully!"
    echo ""
    print_info "Merge commit created:"
    git log -1 --oneline
else
    print_error "Merge failed or has conflicts that need to be resolved."
    echo ""
    print_info "Conflicts in the following files:"
    git status --short | grep "^UU\|^AA\|^DD\|^AU\|^UA"
    echo ""
    print_info "To resolve conflicts:"
    echo "  1. Edit the conflicting files to resolve conflicts"
    echo "  2. Stage the resolved files: git add <file>"
    echo "  3. Complete the merge: git commit"
    echo ""
    print_info "To abort the merge:"
    echo "  git merge --abort"
    echo ""
    print_info "Your backup branch is available at: $BACKUP_BRANCH"
    exit 1
fi

# Show the result
echo ""
print_info "Current branch status:"
git log --oneline --graph --all -10

echo ""
print_info "Files in merged main branch:"
ls -la

echo ""
print_warning "IMPORTANT: Review the changes before pushing!"
print_info "To push the merged changes to remote:"
echo "  git push origin main"
echo ""
print_info "To restore from backup if needed:"
echo "  git reset --hard $BACKUP_BRANCH"
echo ""
print_info "Merge process completed successfully!"
