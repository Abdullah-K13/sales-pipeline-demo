# CI/CD demo — run sheet

Repo lives next to this folder: `../sales-pipeline-demo`
Replace `YOUR_USERNAME` throughout.

## Before class

```bash
docker pull python:3.11-slim        # pre-warm, a cold pull is 2 min of silence
docker info                         # Docker Desktop must be RUNNING
cd ../sales-pipeline-demo
docker build -t sales-etl:demo . && docker run --rm sales-etl:demo
```

Create a **public** repo `sales-pipeline-demo` on GitHub, then:

```bash
cd ../sales-pipeline-demo
git remote add origin https://github.com/YOUR_USERNAME/sales-pipeline-demo.git
git push -u origin main
```

Save the starter SHA for resets: `git rev-parse main`

Two windows open before you start: Actions tab on one screen, terminal on the other.

---

## Demo A — make it go red   (after Ch 2)

```bash
cd ../sales-pipeline-demo
git switch -c feature/add-test
cat ../kit/failing-test.py >> tests/test_transforms.py
mkdir -p .github/workflows
cp ../kit/ci.yml .github/workflows/ci.yml
git add -A
git commit -m "Add CI workflow and a failing test"
git push -u origin feature/add-test
```

Open the PR in the browser. Go to the Actions tab.

**Narrate Ch 3 while it runs** — runner boots, steps run, runner is thrown away.
That is ~50 seconds of dead air the chapter fills exactly.

When it goes red: Details -> the red `Tests` step -> scroll to the bottom.
Read the assertion out loud: `assert np.int64(1500) == 9999`

## Demo B — make it go green

```bash
sed -i 's/== 9999/== 1500/' tests/test_transforms.py
git commit -am "Fix the expected total"
git push
```

Flip to the PR tab, the check re-runs on its own. Point out: CI did not change.
The same pipeline that said no now says yes.

## Demo C — the grey merge button   (while B is running)

Settings -> Branches -> Add rule, pattern `main`:

- [x] Require a pull request before merging
- [x] Require status checks to pass -> select `quality` and `image`
- [x] Do not allow bypassing the above settings   <-- tick this or they see the
      admin override and think it is broken
- [ ] Allow force pushes (leave off)

Back to the PR. Green, so the merge button is live. Merge it.

## Demo D — ship it   (after Ch 4)

```bash
git switch main && git pull
cp ../kit/deploy.yml .github/workflows/deploy.yml
git add -A
git commit -m "Publish the image to GHCR on merge"
git push
```

Watch Actions. Then: **Packages tab -> the image -> Package settings ->
Change visibility -> Public.**

The finale, on a student's laptop if you can:

```bash
docker pull ghcr.io/YOUR_USERNAME/sales-pipeline-demo:latest
docker run --rm ghcr.io/YOUR_USERNAME/sales-pipeline-demo:latest
```

Prints the clean row count and revenue by city. Nothing of yours is installed
on that machine.

---

## Reset between batches

```bash
./reset.sh YOUR_USERNAME
```

Then delete the branch protection rule in Settings -> Branches, or Demo A's
first push gets blocked next time.

---

## Notes on what is different from the student lab

- `data/sales.csv` is included and the Dockerfile has `COPY data/ ./data/`.
  Without it `docker run` exits 2 with "no input file". The student
  `starter/` does NOT have this — tell them to copy it from day 1's lab.
- `ci.yml` here has the `dags:` job removed (no dags/ folder, just noise).
- `ci.yml`'s smoke test runs the real ETL instead of only importing it,
  so CI actually proves the checkpoint-3 finale works.
- `deploy.yml` here has `environment: production` removed so the run does not
  pause for your approval mid-demo. Put it back when you teach that slide.
