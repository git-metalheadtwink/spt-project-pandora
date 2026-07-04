#!/bin/sh
# git clean filter: strips the auto-generated local IP list that BepInEx
# writes into com.fika.core.cfg's "Force Bind IP" comment, so it never
# reaches the git history. Only affects what's staged/committed; the
# working-tree file used by the game is never modified.
sed -E 's/^(# Acceptable values: Disabled, 0\.0\.0\.0, ::,).*/\1 <redacted-local-ips>/'
