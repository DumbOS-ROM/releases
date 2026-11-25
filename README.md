# DumbOS Official Builds & Releases

Central release repository for compiled **DumbOS** ROM packages (`.zip`), recovery/boot images, and SHA-256 checksums.

Every release published here appears automatically on the Downloads portal:
**[https://dumbos-rom.github.io/#downloads](https://dumbos-rom.github.io/#downloads)**

---

## How to Post a New ROM Build

### Option A — Drag & Drop via GitHub Web UI
1. Go to **[New Release](https://github.com/DumbOS-ROM/releases/releases/new)**.
2. Set **Tag** using the format `<codename>-<YYYYMMDD>` (example: `angler-20261125` or `serrano3gxx-20261125`).
3. Set **Release title** (example: `DumbOS (angler) — Android 15`).
4. Attach your `DumbOS-*.zip` (and optional `boot.img` / `.sha256sum`).
5. Click **Publish release**. It goes live on the website immediately.

### Option B — Publish Directly from Build Server (`gh` CLI)
```bash
git clone https://github.com/DumbOS-ROM/releases.git
cd releases
./publish-build.sh angler /path/to/DumbOS-22.2-20261125-UNOFFICIAL-angler.zip "Android 15" "Initial build"
```

---

## Adding a Device Card (`devices.json`)
To register device hardware specs (OEM, model name, SoC/kernel, RAM, status) shown on the website, add an entry to `devices.json` with matching `"codename"`.
