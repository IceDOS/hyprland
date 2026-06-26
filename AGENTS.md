# AGENTS.md — IceDOS **hyprland**

> Utilizes the **IceDOS** framework. The full bible — module structure, config flow,
> the `icedos rebuild --build` test loop, `validate.*` helpers, dep loading — lives in
> **core**: <https://github.com/IceDOS/core/blob/main/AGENTS.md> — this file only
> covers what is specific to **hyprland**.

## Non-negotiable rules (full detail in core)
- Build/test only via the `icedos` CLI — **never `sudo nixos-rebuild`**.
- **Never** `git commit/stash/reset/pull` — the user manages git.
- Every option uses a `validate.*`/`mk*Option` helper; **no untyped options**.
- A module's `config.toml` defaults must mirror its `icedos.nix` defaults.
- Format with `icedos nixf .` after editing any `.nix`.
- If a repo or the config root you need isn't checked out locally, **ask the user** for
  its path or permission to `git clone` it — don't guess or clone unprompted.

## Purpose
The Hyprland tiling Wayland compositor for IceDOS, with plugins, lock/idle, panel and
wallpaper integration.

## Layout (DE repo)
- **Root `icedos.nix`** + root `config.toml` = the DE-wide option schema.
- `modules/<feature>/icedos.nix` = sub-features: `hyprlock`, `hypridle`, `hyprpanel`,
  `hyprpaper`, `hyprpicker`, `hyprspace`, `hyprfreeze`, `hyproled`,
  `hyprland-per-window-layout`, `grimblast`, `eye-wellbeing`, `csgo-vulkan-fix`,
  `playerctl`, `poweralertd`, `sysauth`, `home`.
- `flake.nix` scans the whole repo: `icedosLib.scanModules { path = ./.; filename = "icedos.nix"; }`.

## Module shape here
Standard IceDOS module shape; the **root `icedos.nix` + `config.toml`** carry the
compositor options (plugins, animations, window rules).

## Test a change to this repo
In the config root's `config.toml`, point this repo's `overrideUrl` at your local
checkout (`path:/abs/path/to/hyprland`), then `icedos rebuild --build` (no activation).
Compositor changes apply on a `switch` + session restart — the **user's** call.

## Notable modules / gotchas
- Lock/idle (`hyprlock`/`hypridle`), bar (`hyprpanel`), wallpaper (`hyprpaper`),
  overview (`hyprspace`), per-window keyboard layout.
- Session-scoped behavior usually needs a relogin; validate with `--build` first.
