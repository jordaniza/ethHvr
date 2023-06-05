# ethHvr
Hover over numbers and strings in neovim to show conversions to and from within a popup

## Developing

Install:

```
make install
```

Test:

```
make test
```

Run this from the nvim command line when testing

```vimscript
:lua package.loaded['ethHvr'] = nil; require('ethHvr').main()
```
