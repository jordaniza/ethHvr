# ethHvr
Hover over numbers and strings in neovim to show conversions to and from within a popup

## Installing

With Lazy:

```
{
 'jordaniza/ethHvr',
}
```
There is one command `:EthHvr`. Use it when your cursor is over a numeric (wei) value and a popup will appear with the Eth equivalent. 

## Features

- [x] Wei to Eth (18 decimals)
- [ ] Support for other decimals
- [ ] Eth to wei

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
