#!/usr/bin/env python3
# Merge the desired per-type default handlers into the macOS LaunchServices
# preferences, preserving every unrelated entry.
#
# An extension with no registered UTI can only be associated through an
# LSHandlerContentTag/public.filename-extension entry, so each association maps
# to either an LSHandlerContentType (UTI) or an LSHandlerContentTag (extension).
# The preferences are only rewritten when the merged table differs from what is
# stored. The apps are registered with lsregister and the preferences are backed
# up (rotating, 10 deep) before a write; afterwards the result is re-read and
# checked, restoring the backup on any mismatch. The managed keys are recorded in
# a state file so associations that disappear are cleaned up.
#
# Usage:
#   set-mac-handlers.py <ls-domain> <desired.json> <state.json> [apps.json]
import glob
import json
import os
import plistlib
import pwd
import shutil
import subprocess
import sys
import tempfile
import time

DEFAULTS = "/usr/bin/defaults"
KILLALL = "/usr/bin/killall"
LSREGISTER = (
    "/System/Library/Frameworks/CoreServices.framework"
    "/Frameworks/LaunchServices.framework/Support/lsregister"
)
KEEP_BACKUPS = 10


def warn(msg):
    print(f"set-mac-handlers: WARNING: {msg}", file=sys.stderr)


def info(msg):
    print(f"set-mac-handlers: {msg}")


def key(entry):
    if entry.get("LSHandlerContentTagClass") == "public.filename-extension":
        tag = entry.get("LSHandlerContentTag")
        return ("tag", tag) if tag else None
    ctype = entry.get("LSHandlerContentType")
    return ("type", ctype) if ctype else None


def export_db(domain, path):
    """Return the whole preference plist, or None if the domain doesn't exist."""
    if subprocess.run([DEFAULTS, "export", domain, path]).returncode != 0:
        return None
    if not os.path.exists(path):
        return None
    with open(path, "rb") as f:
        return plistlib.load(f)


def import_db(domain, path):
    return subprocess.run([DEFAULTS, "import", domain, path]).returncode == 0


def write_db(path, db):
    with open(path, "wb") as f:
        plistlib.dump(db, f)
    return path


def kill_lsd():
    subprocess.run([KILLALL, "-u", pwd.getpwuid(os.getuid()).pw_name, "lsd"], check=False)


def register(apps):
    """Teach LaunchServices about our apps so handler bundle ids resolve."""
    if not os.path.exists(LSREGISTER):
        return
    for app in apps:
        if os.path.isdir(app):
            subprocess.run(
                [LSREGISTER, "-f", app], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            )


def backup(snapshot, state_path):
    backup_dir = os.path.join(os.path.dirname(state_path), "backups")
    os.makedirs(backup_dir, exist_ok=True)
    stamp = time.strftime("%Y%m%d-%H%M%S")
    shutil.copy(snapshot, os.path.join(backup_dir, f"launchservices-{stamp}.plist"))
    stale = sorted(glob.glob(os.path.join(backup_dir, "launchservices-*.plist")))
    for old in stale[:-KEEP_BACKUPS]:
        os.remove(old)


def verify(domain, tmp, desired_map, owned, before):
    """Re-read the database and confirm the write landed intact."""
    unrelated_before = {k for e in before if (k := key(e)) and k not in owned}
    for _ in range(4):
        after = (export_db(domain, os.path.join(tmp, "verify.plist")) or {}).get("LSHandlers", [])
        present = {k: e.get("LSHandlerRoleAll") for e in after if (k := key(e))}
        if all(present.get(k) == role for k, role in desired_map.items()) and (
            unrelated_before <= set(present)
        ):
            return True
        time.sleep(0.3)
    return False


def load_managed(state_path):
    if os.path.exists(state_path):
        try:
            with open(state_path) as f:
                return {tuple(k) for k in json.load(f)}
        except (ValueError, OSError):
            pass
    return set()


def main():
    if len(sys.argv) < 4:
        sys.exit(f"usage: {sys.argv[0]} <ls-domain> <desired.json> <state.json> [apps.json]")
    domain, desired_path, state_path = sys.argv[1:4]
    apps_path = sys.argv[4] if len(sys.argv) > 4 else None

    with open(desired_path) as f:
        desired = json.load(f)
    apps = []
    if apps_path and os.path.exists(apps_path):
        with open(apps_path) as f:
            apps = json.load(f)

    register(apps)
    owned = load_managed(state_path) | {k for e in desired if (k := key(e))}
    desired_map = {k: e["LSHandlerRoleAll"] for e in desired if (k := key(e))}

    with tempfile.TemporaryDirectory() as tmp:
        snapshot = os.path.join(tmp, "current.plist")
        db = export_db(domain, snapshot)
        handlers = (db or {}).get("LSHandlers", [])

        merged = [e for e in handlers if key(e) not in owned]
        merged.extend(desired)

        if merged == handlers:
            info("no changes")
        else:
            new_db = dict(db or {})
            new_db["LSHandlers"] = merged
            if not import_db(domain, write_db(os.path.join(tmp, "new.plist"), new_db)):
                warn("could not import the merged database; left untouched")
            else:
                if db is not None:
                    backup(snapshot, state_path)
                if verify(domain, tmp, desired_map, owned, handlers):
                    kill_lsd()
                    info(f"applied {len(desired_map)} associations")
                elif db is None:
                    warn("verification failed and there was nothing to restore")
                elif import_db(domain, snapshot):
                    kill_lsd()
                    warn("verification failed; restored the previous database")
                else:
                    sys.exit(
                        "set-mac-handlers: ERROR: verification and rollback both failed; "
                        "the LaunchServices database may be inconsistent"
                    )

    os.makedirs(os.path.dirname(state_path), exist_ok=True)
    with open(state_path, "w") as f:
        json.dump(sorted(desired_map), f)


if __name__ == "__main__":
    main()
