# mlops_cv: HR job candidate shortlisting (MLOps Operationalization Workshop)

Environment setup for the **HR shortlisting** use case of the MLOps Operationalization Workshop
(Addis Ababa, 27–30 October 2026).

The HR use case runs on the shared **MLOps-Workshop** environment. Nothing extra is installed:
the synthetic CVs and job descriptions ship inside the HR repository itself.

## Layout

This folder acts as the workshop's `mlops/` parent folder. The cloned repositories are ignored by git.

```
mlops_cv/
  setup.sh            one-shot setup (clone/update, environment, setup check)
  setup_report.txt    latest output of MLOps-Workshop/check_setup.py
  MLOps-Workshop/     provides .venv (Python 3.12 + packages from requirements.lock, ~1.5 GB)
  HR_use-case/        clone here once the organisers publish the link
```

## Setup

Prerequisites: `git` and `uv` (see the workshop setup guide; uv installs Python 3.12 itself).

```bash
bash setup.sh                     # macOS, Linux, or Git Bash on Windows
HR_REPO=<link> bash setup.sh      # once the HR repository link is known
```

Re-run `bash setup.sh` on Monday 26 October to pick up demo updates (it pulls and re-syncs).

## Working on the HR use case

Activate the workshop environment, then run the HR repository's commands from `HR_use-case/`:

```bash
source MLOps-Workshop/.venv/bin/activate      # Windows: MLOps-Workshop\.venv\Scripts\activate
cd HR_use-case
```

In VSCode, open this folder and choose `MLOps-Workshop/.venv` as the Python interpreter.

## Setup check

`setup.sh` ends by running `python check_setup.py` and copies the result to `setup_report.txt`.
Send it to the organisers by Friday 23 October.

The report's data download items (Zambia TB table, guideline PDFs) and the OpenRouter reachability
check belong to the other demos, not to the HR use case. They show FAIL when the machine cannot
reach `kaggle.com`, `ephi.gov.et`, or `openrouter.ai`.
