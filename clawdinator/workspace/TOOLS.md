---
summary: "Workspace template for TOOLS.md"
read_when:
  - Bootstrapping a workspace manually
---
# TOOLS.md - Local Notes

Skills define *how* tools work. This file is for *your* specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:
- Camera names and locations
- SSH hosts and aliases  
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH
- home-server → 192.168.1.100, user: admin

### TTS
- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## CLAWDINATOR Tooling Audit

Quick checks:
- Binaries: `ls /run/current-system/sw/bin`
- Active system profile: `readlink /run/current-system/sw`
- NixOS package list: `nix-store --query --requisites /run/current-system/sw | sort`

CLAWDINATOR-specific tools:
- `/usr/local/bin/memory-read`
- `/usr/local/bin/memory-write`
- `/usr/local/bin/memory-edit`

Seeded repos:
- `/var/lib/clawd/repos/clawdbot`
- `/var/lib/clawd/repos/nix-clawdbot`
- `/var/lib/clawd/repos/clawdinators`
- `/var/lib/clawd/repos/clawdhub`
- `/var/lib/clawd/repos/nix-steipete-tools`
