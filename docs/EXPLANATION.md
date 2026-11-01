# How this project works

A plain-English walkthrough of what was built, how each piece fits together, and why it was built this way. Useful if someone asks "so what did you actually do?"

## The goal

Take an older Samsung smart TV and:

1. Remove as much tracking and clutter as the TV allows.
2. Give it a modern, good-looking home screen.
3. Keep everything simple enough to set up again after a reset.

## The constraint that shaped everything

The TV is a **2015 Samsung running Tizen 2.3**. That matters for three reasons:

- **Samsung locks the system.** Built-in apps live on a read-only partition and can't be removed, and the home screen can't be replaced.
- **The web engine is from 2015.** Modern visual effects like frosted-glass blur, CSS variables and modern JavaScript don't work on it.
- **Community tools skip it.** The well-known Samsung debloat and homebrew projects all require 2017 or newer models.

So instead of fighting the TV, the project works around it in two ways.

## Piece 1: the privacy cleanup

The most effective changes were settings, not code:

- Declining **SyncPlus**, which can recognize what's on screen for ad targeting
- Declining interest-based ads and voice recognition
- Pointing the TV's **DNS** at an ad-blocking resolver, which blocks many ad and telemetry servers at the network level

The full checklist is in [PRIVACY-CLEANUP.md](PRIVACY-CLEANUP.md).

## Piece 2: the PC launcher (`pc/`)

A single self-contained HTML file that runs full-screen in a browser on a PC plugged into the TV. Because it runs on the PC, it can use every modern effect.

**How it's built**
- One list of apps (`APPS`) drives all three looks, so adding an app updates Glass, Console and Simple together.
- **Keyboard navigation** works like a TV remote: it finds the nearest tile in the direction you press, so the same code works for the horizontal row, the vertical list and the big grid.
- **Weather** comes from Open-Meteo's free API (no account needed) and is cached so the last reading shows even offline.
- **Background photos** fade between two layers so there's never a blank frame. Your own photos are stored in the browser's IndexedDB so they're remembered next time.
- The background **canvas** animates slowly and tints itself to the selected app's color.

**Why Brave:** its built-in Shields block ads and trackers without any extra extensions.

## Piece 3: the TV app (`tv-app/`)

The same idea rewritten for the TV's 2015 engine: fixed 1920×1080 layout, older JavaScript (ES5), prefixed CSS and no blur.

**What's different on the TV**
- On startup it asks the TV which apps are installed (`tizen.application.getAppsInfo`) and matches them by name, so tiles open the real Netflix, YouTube and so on. Apps the TV doesn't have are dimmed instead of failing silently.
- It registers the remote's **color buttons** so red, green and yellow switch looks.

**How it gets onto the TV**

1. The TV's **Developer Mode** is turned on and pointed at the PC's IP address.
2. `Setup-Everything.bat` downloads Samsung's official **Tizen SDK** command-line tools.
3. `Install-TV-App.bat` then:
   - connects to the TV with `sdb` (Samsung's equivalent of Android's `adb`)
   - creates a local **author certificate** and pairs it with Tizen's standard distributor certificate (accepted by this 2015 model)
   - packages the app into a signed `.wgt` file
   - installs it on the TV and logs every step to `install-log.txt`

**Lessons learned along the way**
- Samsung retired "Tizen Studio"; the tools now ship as the **Tizen SDK**.
- The TV's installer rejected a package whose file name contained a space, so the script renames it to `TVLauncher.wgt`.
- This firmware blocks launching apps remotely over `sdb`, so the app is opened from **Smart Hub → Apps**.
- 2015 models may remove sideloaded apps after a restart, which is why reinstalling is a one-click step.

## Decisions and why

| Decision | Reason |
| --- | --- |
| PC over HDMI as the main experience | The only way to get a modern interface on this TV at full quality. |
| No rooting | Only works on specific old firmware and can permanently brick the TV. |
| Original designs, generic icons | The looks are inspired by familiar styles without copying anyone's UI or logos. |
| Only licensed streaming services in the tiles | Unofficial streaming sites are a common source of malware and scam pop-ups, which defeats the point of a privacy cleanup. |
| Everything editable at the top of each file | So the setup can be changed or redone without digging through code. |

## Security notes

- Developer Mode lets the paired PC install apps on the TV. Turn it off when you're done (**Apps → 1 2 3 4 5 → Off**) unless you plan to reinstall soon.
- The signing key is created locally and never leaves the PC.
- Downloads come only from official sources: Samsung (download.tizen.org) and Brave (via winget).
