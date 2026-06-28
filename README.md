# PlayMon-for-MacOS
A lightweight macOS system monitor with a to-do list, habit tracker, and unit converter — one shell script, no Electron, no Chrome.

 The UI runs in Apple's native WKWebView (same engine as Safari). A small Python HTTP server runs locally on port `9876` and feeds live system stats to the UI every second.

## Temperature

CPU temperature requires one of the following:

- [`osx-cpu-temp`](https://github.com/lavoiesl/osx-cpu-temp) — `brew install osx-cpu-temp`
- [`iStats`](https://github.com/Chris911/iStats) — `gem install iStats`

Without either, the temperature field shows `N/A`. Everything else works fine.

## Dock

Drag `PlayMon.app` from your Desktop to the Dock to pin it.

## Uninstall

```bash
rm -rf ~/Desktop/PlayMon.app ~/.playmon-data
```

## License

MIT
