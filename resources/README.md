# Bundled resources

Files here are copied into the Chromium tree before a build by
`helium-linux/scripts/apply-resources.sh`.

## bangs.json

The !bang list that OmaBrowse ships built in, so bangs work without contacting
any server. It is the file Helium's own service serves at `/bangs.json`.

- Source: `svc/bangs/bangs.json` in https://github.com/imputnet/helium-services
  (the commit used is in `bangs.json.source-commit`).
- Generated upstream by `svc/bangs/mkbangs.mjs` from https://github.com/kagisearch/bangs
  plus imput's `extras.json`. MIT licence, Copyright (c) 2024 Kagi Search, 2026 imput;
  the full licence text is embedded at the top of the file.
- Installed to `components/search_engines/resources/omabrowse_bangs.json` and
  compiled into `components_resources.pak` as `IDR_OMABROWSE_BANGS_JSON`
  (see `omarchy-patches/0050-omarchy-bundled-bangs.patch`).

To refresh: copy a newer `svc/bangs/bangs.json` from helium-services over this
file, update `bangs.json.source-commit`, and rebuild. The browser reads the
JSON array of objects with keys `s` (name), `ts` (triggers), `u` (URL template)
and optional `sc` (category).
