A [web configuration tool](https://sgtlaggy.github.io/spt-trader-namer/) is available to configure trader details without manually editing the JSON config.

The novel difference from other avatar-swapping mods is that it uses trader nicknames instead of obscure avatar IDs that don't match the trader ID.

Instead of using a trader’s nickname you can use either their regular ID (for compatibility with Windows filename restrictions) or avatar ID (to easily switch from other avatar-switching mods).

Both features of the mod should work for custom traders as long as this mod loads after them.

# {.tabset}

## Name Examples
Edit `config.json` and add a new line between the `{}` in the format `"Default Name": "New Name"`.

The key (left) should be the trader's default nickname/ID like `Prapor` or `54cb50c76803fa8b248b4571`, the value (right) is what you want their new name to be.

Examples:
```json
{
    "Prapor": "Sidorovich"
}
```
```json
{
    "Prapor": "Sidorovich",
    "Fence": "Drebin"
}
```
Details like the trader's Location and Description can also be changed with extended syntax.
Valid keys are "FullName", "FirstName", "Nickname", "Location", and "Description". All are case-sensitive.
```json
{
  "Prapor": {
    "Nickname": "Sidorovich",
    "Location": "Rookie Village in the Cordon",
    "Description": "A reliable source of equipment for stalkers."
  },
  "Fence": "Drebin"
}
```

## Avatars
Name an image based on the trader's default nickname/ID like `Prapor.jpg`, `54cb50c76803fa8b248b4571.jpg`, or `59b91ca086f77469a81232e4.jpg` and put it in the mod's `avatars` folder.

Images should be JPEG or PNG and sizes around 500x500 work best.

All users will need to go into their launcher settings and select `Clean Temp Files` for avatars to update.

## Language
By default names are looked up using your `system` language but this can be changed in `config.json`. You can find language codes in `SPT_Data/Server/database/locales/`; the value for English is `en`, Russian is `ru`, etc.
