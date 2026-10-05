# Build with FBC-Modern — 64-bit only

This branch (`fbc-modern`) is compiled with **FBC-Modern**, not stock FreeBASIC.

- Compiler: [Alice2Git/FBC-Modern](https://github.com/Alice2Git/FBC-Modern), branch `lambda-fixes`, commit `68f487b`
  (`toolchains/fbc-modern-windows/fbc64.exe`, fbc 1.20.0, win64)
- Framework: [Alice2Git/MyFbFramework](https://github.com/Alice2Git/MyFbFramework), branch `fbc-modern`
- Source change needed: `UString` renamed to `UStringX`, because FBC-Modern has a built-in `USTRING` type.

## Only the 64-bit binary was rebuilt

| File | State |
|---|---|
| `VisualFBEditor64.exe` | rebuilt with FBC-Modern (2026-10-05) |
| `VisualFBEditor32.exe` | **removed** — the 32-bit build is not used |
| `Controls/*` DLLs (MariaDBBox, SQLite3, ScintillaControl, cJSON), `AddIns/*` | **not rebuilt** — still the original builds |

**Why:** only the 64-bit version is used. The 32-bit executable was removed, so that no
old build (made with stock FreeBASIC, still using the old `UString` name) stays next to the
new sources. This branch is worked on from two machines: do not expect 32-bit binaries,
and do not rebuild them unless that decision changes.

The sources themselves still support 32-bit (`#ifdef __FB_64BIT__` branches are untouched).
For the record: a 32-bit test build with FBC-Modern `fbc32.exe` stopped at
`src/frmProjectProperties.bi(100) error 14: Expected identifier, found 'frmProjectProper'`;
not investigated, since 32-bit is not needed.

The components in `Controls/` also use `UString` (renamed in their sources) but were not
recompiled; they may need a rebuild with FBC-Modern to work with the new `mff64.dll`.

## Command used (Windows)

MyFbFramework cloned next to this repo (`..\MyFbFramework`, branch `fbc-modern`):

```bat
cd src
fbc64.exe "VisualFBEditor.bas" -s gui -gen gcc -Wc -O2 -x "../VisualFBEditor64.exe" "VisualFBEditor.rc" -i "..\..\MyFbFramework"
```
