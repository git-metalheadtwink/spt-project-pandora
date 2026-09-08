# Active Combat Revive

A Fika addon that replaces hold-to-revive with field surgery.

In stock Fika a downed teammate is brought back by walking up to their body and holding the
interact key for a few seconds. This mod removes that entirely. Bringing somebody back now costs a
real surgical kit, takes as long as the kit's own vanilla use time, and can be interrupted.

## How it plays

**Stabilize (optional, but the reason it works).** A downed teammate bleeds out on a timer. Before
anything else you can apply a tourniquet or haemostatic to clot the bleeding, which freezes that
timer indefinitely. That buys you time to break contact and clear the room instead of being forced
to perform a 20 second operation while under fire.

A stabilized player cannot give up. This is deliberate, not an oversight: their bleeding has been
stopped, so there is nothing left to bleed out from, and they wait for their ride whether they like
it or not. It falls out of Fika gating its give-up key behind the bleeding state
(`Bleedout.Update` returns early when `_shouldBleed` is false), and the behaviour is kept on
purpose. A team wipe still kills them correctly, since that path is event driven and bypasses the
flag. Do not "fix" this.

**Operate.** With a CMS or Surv12 in your kit, interact with the downed player and choose to
operate. Your character performs the real surgical-kit animation, and so does your character on
everyone else's screen. When it completes, they are back up.

**Hold still.** The operation is cancelled if you move more than a short distance from where you
started, if you take combat damage, if you go down yourself, or if you lose the kit. Bleed ticks
and metabolism damage are ignored, so a light bleed will not ruin the procedure.

## Kits

Values come straight from the item templates, so they track the game rather than being invented.

| Kit    | Operations | Time |
| ------ | ---------- | ---- |
| CMS    | 3          | 16s  |
| Surv12 | 9          | 20s  |

Surgical kits declare an `HpResourceRate` of zero, which in vanilla means exactly one point of
`HpResource` is consumed per use and the item is destroyed once empty. This mod reproduces that,
including the vanilla rule that an operation interrupted past the game's grace period still burns a
charge.

Your Surgery skill speeds operations up on the same curve the vanilla surgery does.

Tourniquets (CAT, Esmarch) have no resource pool and are consumed whole, again matching vanilla.
CALOK-B has three uses.

## Compatibility

Only the surgeon needs the mod. The revive itself is delivered through Fika's own revived packet,
and the bleedout freeze rides on Fika's existing reviving state, so a teammate without the mod is
still stabilized and still revived correctly. They will just see a slightly plainer caption while
they are stabilized.

Requires Fika with revive enabled server-side (`ReviveConfig.enabled`). Fika's own `reviveTime`
setting no longer applies, since timing comes from the kit.

## Configuration

All settings live under `Active Combat Revive` in the BepInEx configuration manager.

- **Allow Stabilizing** — enable the tourniquet step.
- **Surgery Skill Affects Speed** — scale operation time with the Surgery skill.
- **Surgery Time Override** — fixed time in seconds; `0` uses each kit's own use time.
- **Surgery Kit Template Ids** — comma separated; add modded kits here.
- **Stabilize Template Ids** — comma separated haemostatics.
- **Cancel On Damage** — abort when the surgeon takes combat damage.
- **Max Move Distance** — drift allowed before aborting; `0` disables the check.
- **Consume Kit On Late Interrupt** — mirror the vanilla late-interrupt charge loss.

## Building

```bash
dotnet build ActiveCombatRevive/ActiveCombatRevive.csproj -c Release
```

A Release build does two things beyond compiling.

It copies the plugin into `BepInEx/plugins` of the SPT install three levels up, so the change is
live without any extra step. Point that elsewhere with `-p:DeployPath=...`, or turn it off with
`-p:Deploy=false`.

It also writes `dist/ActiveCombatRevive-<version>.zip`, laid out so it can be extracted straight
onto a game folder:

```
BepInEx/plugins/ActiveCombatRevive.dll
README.md
```

Bump the version in `<Version>` in the csproj; the zip name follows it. To package without a full
rebuild, run `dotnet build ActiveCombatRevive/ActiveCombatRevive.csproj -c Release -t:Package`.
Debug builds skip packaging.

## How it works

Three hooks carry the whole feature.

`ReviveInteractable.GetActions` is postfixed to throw away Fika's revive action and build the
surgery menu in its place.

The kit is put in the surgeon's hands with the stock `Player.Proceed` meds overload. Fika already
mirrors that call to every other client through its observed meds controller, so remote players see
the genuine animation without any new networking.

`MedsInHandsOperation.GoNextBodyPart` is prefixed and skipped while an operation is running. Left
alone it asks the health controller for a med effect on the *surgeon's* body, gets nothing back
because they have no blacked limb, and aborts the animation instantly. Suppressing it leaves the
animation looping, and `SurgeryOperation` owns the timing and the ending.
