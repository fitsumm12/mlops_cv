#!/usr/bin/env bash
# MLOps Operationalization Workshop: environment for the HR (job candidate shortlisting) use case.
#
# The HR use case runs on the MLOps-Workshop environment; there is nothing extra to install.
# Its synthetic CVs and job descriptions ship inside the HR repository itself.
#
# Layout (this folder plays the role of the `mlops/` parent):
#   mlops_cv/
#     MLOps-Workshop/      cloned here, provides .venv (Python 3.12 + locked packages, ~1.5 GB)
#     HR_use-case/         cloned here once the organisers publish the link
#
# Usage:  bash setup.sh                      # clone/update MLOps-Workshop, build .venv, run the check
#         HR_REPO=<link> bash setup.sh       # also clone the HR repository once its link is known
#
# Safe to re-run (pulls, re-syncs). On Monday 26 October run it again to pick up demo updates.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSHOP_REPO="https://github.com/ydfriedman/MLOps-Workshop.git"
HR_REPO="${HR_REPO:-}"

step() { printf '\n==> %s\n' "$*"; }

step "Checking base tools"
for tool in git uv; do
  command -v "$tool" >/dev/null || { echo "missing: $tool (see the setup guide)"; exit 1; }
done
git --version
uv --version

clone_or_pull() {   # url, folder
  if [[ -d "$2/.git" ]]; then
    step "Updating $2"; git -C "$2" pull --ff-only
  else
    step "Cloning $2"; git clone "$1" "$2"
  fi
}

clone_or_pull "$WORKSHOP_REPO" "$ROOT/MLOps-Workshop"
cd "$ROOT/MLOps-Workshop"
step "Creating the workshop environment (Python 3.12)"
[[ -d .venv ]] && echo ".venv already exists, keeping it" || uv venv --python 3.12 --seed .venv
step "Installing the locked workshop packages (about 1.5 GB)"
uv pip sync requirements.lock --python .venv

if [[ -n "$HR_REPO" ]]; then
  clone_or_pull "$HR_REPO" "$ROOT/HR_use-case"
else
  step "HR repository: link not published yet; re-run with HR_REPO=<link> when it is"
fi

step "Running the setup check (saves MLOps-Workshop/setup_report.txt)"
if [[ -x .venv/Scripts/python.exe ]]; then PY=.venv/Scripts/python.exe; else PY=.venv/bin/python; fi
"$PY" check_setup.py || true
cp setup_report.txt "$ROOT/setup_report.txt"

cat <<MSG

Done. To work on the HR use case, activate the workshop environment first:
  macOS / Linux:  source $ROOT/MLOps-Workshop/.venv/bin/activate
  Windows:        $ROOT\\MLOps-Workshop\\.venv\\Scripts\\activate
then run the HR repository's commands from $ROOT/HR_use-case.
Send $ROOT/setup_report.txt to the organisers by Friday 23 October.
MSG
