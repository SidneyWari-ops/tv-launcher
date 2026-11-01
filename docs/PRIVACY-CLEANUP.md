# Privacy cleanup for a 2015 Samsung smart TV

These are the steps used on a Samsung UN75JU6500F (2015, Tizen). Menu names can differ slightly between models and firmware versions.

## 1. Turn off viewing-data collection (biggest impact)

Samsung's SyncPlus feature can recognize what's on screen and use it for ads. Turn it off along with the related policies.

**MENU → Smart Hub → Terms & Policy** (on some models: **MENU → System → Smart Hub Terms & Conditions**, or **MENU → Smart Features → Terms & Policy**)

Disagree or turn off:
- **SyncPlus and Marketing** (also called Viewing Information Services)
- **Interest-Based Advertisements**
- **Voice Recognition** / Nuance
- **Yahoo Privacy Policy**, if listed

Leave the main **Smart Hub Terms & Conditions** agreed only if you still want the TV's built-in apps. Disagreeing to it turns Smart Hub off entirely.

Afterwards, **unplug the TV for about 60 seconds** so the changes stick.

## 2. Block ad and tracking servers with DNS

**MENU → Network → Network Status → IP Settings → DNS Setting → Enter manually**

Enter `94.140.14.14` (AdGuard's free ad-blocking DNS). If an app stops loading, switch DNS back to automatic to check whether the filter is the cause.

## 3. Reduce Smart Hub clutter

**MENU → Smart Hub**
- **Autorun Smart Hub**: Off
- **Autorun Last App**: Off

Delete apps you never use: select the app, press **TOOLS**, then **Delete**.

This is mainly about speed and fewer promoted banners; it doesn't stop background tracking on its own.

## 4. The strongest option

Disconnect the TV from Wi-Fi (**MENU → Network → Network Settings**) and use a PC over HDMI or a streaming stick instead. A TV that can't get online can't send anything anywhere.

## What isn't possible on this model

- **Removing Samsung's built-in apps.** They are signed system packages on a read-only partition; developer mode can't uninstall them.
- **Replacing the home screen.** 2015 models don't allow a custom launcher; the TV app in this project runs inside Smart Hub.
- **Community debloat tools.** Projects like TizenBrew and AeroTizen need 2017 or newer TVs.
- **Rooting.** Community rooting for this generation only works on specific old firmware and can permanently brick the TV.

## After a firmware update or factory reset

Re-check steps 1 to 3. Updates and resets can turn tracking settings back on.
