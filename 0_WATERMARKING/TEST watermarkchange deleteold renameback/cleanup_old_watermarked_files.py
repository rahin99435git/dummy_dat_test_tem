
from pathlib import Path
from datetime import datetime

# Use the directory from which this script is launched.
ROOT = Path.cwd()

# SAFETY: True = preview deletions; False = permanently delete old files.
DRY_RUN = False

# Keep files modified at or after one hour before the watermarking output time.
# Watermarked output timestamp: 23 October 2026, 21:37.
# Cutoff: 23 October 2026, 20:37 (local time).
cutoff = datetime.strptime(
    "2026-10-23 20:37:00",
    "%Y-%m-%d %H:%M:%S"
).timestamp()

matched = 0
deleted = 0
errors = 0

# STEP 1: Recursively delete files modified before the cutoff.
for path in ROOT.rglob("*"):
    if not path.is_file():
        continue

    try:
        # Keep files modified at or after the cutoff.
        if path.stat().st_mtime >= cutoff:
            continue

        # Preview or delete files modified before the cutoff.
        if DRY_RUN:
            print(f"[PREVIEW DELETE] {path}")
        else:
            path.unlink()
            print(f"[DELETED] {path}")
            deleted += 1

        matched += 1

    except OSError as exc:
        errors += 1
        print(f"[DELETE ERROR] {path}: {exc}")

# STEP 2: Rename remaining watermarked WebP files.
renamed = 0
skipped = 0

for path in ROOT.rglob("*"):
    if not path.is_file():
        continue

    # Only process filenames ending with "_wm.webp".
    if not path.name.lower().endswith("_wm.webp"):
        continue

    # Remove "_wm" while preserving the ".webp" extension.
    new_path = path.with_name(path.name[:-8] + ".webp")

    try:
        # Never overwrite an existing destination file.
        if new_path.exists():
            print(f"[SKIPPED — TARGET EXISTS] {new_path}")
            skipped += 1
            continue

        path.rename(new_path)
        print(f"[RENAMED] {path.name} -> {new_path.name}")
        renamed += 1

    except OSError as exc:
        errors += 1
        print(f"[RENAME ERROR] {path}: {exc}")

# STEP 3: Print the final summary.
print("\n--- CLEANUP SUMMARY ---")
print(f"Root scanned: {ROOT}")
print(f"Cutoff: {datetime.fromtimestamp(cutoff)}")
print(f"Old files matched: {matched}")
print(f"Old files deleted: {deleted}")
print(f"Files renamed: {renamed}")
print(f"Renames skipped (target exists): {skipped}")
print(f"Errors: {errors}")
print(f"Mode: {'PREVIEW ONLY' if DRY_RUN else 'LIVE DELETION'}")
