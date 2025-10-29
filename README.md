# java-quarkus-playground
A minimal Quarkus service to prove startup time, memory footprint, and container density vs your Spring services. Scope: REST + Postgres (Panache) + Kafka consumer + Micrometer/Prometheus. Ships JVM and Native builds, Dockerfiles, GitHub Actions, and K8s manifests.

## Branch Management

**[📚 Documentation Index](DOCUMENTATION_INDEX.md)** - Complete guide to all documentation

This repository contains documentation for merging branches with different commit histories:

- **[Quick Reference](QUICK_MERGE_REFERENCE.md)** - Fast commands to merge dev into main
- **[Comprehensive Guide](MERGE_GUIDE.md)** - Detailed explanation of merging unrelated histories
- **[Branch Visualization](BRANCH_VISUALIZATION.md)** - Visual guide to understanding the branch situation
- **[FAQ](FAQ.md)** - Frequently asked questions about merging branches
- **[Automated Script](merge-dev-to-main.sh)** - Safe merge script with conflict resolution guidance

To merge the `dev` branch into `main` when they have different commit histories, see the documentation above or run:
```bash
./merge-dev-to-main.sh
```
