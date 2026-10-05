# Build with FBC-Modern

This branch (`fbc-modern`) is compiled with **FBC-Modern**, not stock FreeBASIC.

- Compiler: [Alice2Git/FBC-Modern](https://github.com/Alice2Git/FBC-Modern), branch `lambda-fixes`, commit `68f487b`
  (`toolchains/fbc-modern-windows/fbc64.exe`, fbc 1.20.0)
- Framework: [Alice2Git/MyFbFramework](https://github.com/Alice2Git/MyFbFramework), branch `fbc-modern`
- Source change needed: `UString` renamed to `UStringX`, because FBC-Modern has a built-in `USTRING` type.

## Binaries

| File | State (2026-10-05) |
|---|---|
| `VisualFBEditor64.exe` | rebuilt with `fbc64.exe` |
| `VisualFBEditor32.exe` | rebuilt with `fbc64.exe -target win32` (**not** `fbc32.exe`, see below) |
| `Controls/*` DLLs (MariaDBBox, SQLite3, ScintillaControl, cJSON), `AddIns/*` | **not rebuilt** — still the original builds |

`VisualFBEditor32.exe` matches `*32.exe` in `.gitignore`, like in the original repo; it is
tracked anyway (added with `git add -f`).

History: commit `01aad2ec` had only the 64-bit exe (32-bit was removed); the 32-bit one was
added back later the same day so that the repo is complete.

The components in `Controls/` also use `UString` (renamed in their sources) but were not
recompiled; they may need a rebuild with FBC-Modern to work with the new `mff*.dll`.

### Why 32-bit is built with `fbc64.exe -target win32`

FBC-Modern's `fbc32.exe` (the compiler running as a 32-bit process) fails on this project with

```
src/frmProjectProperties.bi(100) error 14: Expected identifier, found 'frmProjectProper'
```

on a correct line. The type is defined (`#print typeof(frmProjectProperties)` works right
before it), and the text after "found" changes when the line moves (`'frmProj'`), which
points to memory corruption inside the compiler, not to the code. It is not a memory limit
(peak about 200 MB). `fbc64.exe -target win32` compiles the same sources without errors.
Not fixed in FBC-Modern (that repo is kept read-only).

## Folder layout

MyFbFramework is cloned **twice**, both on branch `fbc-modern` of
[Alice2Git/MyFbFramework](https://github.com/Alice2Git/MyFbFramework):

```
V:\ProiecteClaude\
├─ MyFbFramework\                      separate project (framework work happens here)
├─ VisualFBEditor\
│  └─ Controls\MyFbFramework\          second clone, used by the editor at run time
└─ FBC-Modern\                         compiler, read-only
```

- `Controls\MyFbFramework` is the standard VisualFBEditor layout: the editor loads the
  designer library from `Controls\MyFbFramework\mff64.dll` (or `mff32.dll`), and the
  `MFFPath` setting points there. The folder is ignored by this repo's `.gitignore`.
- The two clones are separate: a change made in one reaches the other only through
  commit + push, then `git pull` in the other.

```bat
git clone -b fbc-modern https://github.com/Alice2Git/MyFbFramework.git Controls\MyFbFramework
```

## Commands used (Windows)

```bat
cd src
fbc64.exe "VisualFBEditor.bas" -s gui -gen gcc -Wc -O2 "VisualFBEditor.rc" -i "..\Controls\MyFbFramework"
fbc64.exe -target win32 "VisualFBEditor.bas" -s gui -gen gcc -Wc -O2 "VisualFBEditor.rc" -i "..\Controls\MyFbFramework"
```

`VisualFBEditor.bas` contains `#cmdline "-x ../VisualFBEditor64.exe"` / `"-x ../VisualFBEditor32.exe"`,
so the output always goes there.

Both exes were built against MyFbFramework `d475752` (`VisualFBEditor64.exe` with
`-i "..\..\MyFbFramework"`, the separate clone; `VisualFBEditor32.exe` with
`-i "..\Controls\MyFbFramework"`). The later `c1ccd66` only adds binaries and notes.

## Tested

2026-10-05, on both `VisualFBEditor64.exe` and `VisualFBEditor32.exe`: the editor starts,
the form designer and the code editor work. The only error was "compiler not found", because
the compiler paths in `Settings\VisualFBEditor*.ini` point to folders that do not exist on
this machine; that is expected. Only the existing FreeBASIC 1.20 language is used so far:
no generics, `FOR EACH`, lambdas or `defer`.
