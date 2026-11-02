# Third-party notices

OmaBrowse is a fork of Helium, which is itself a patched build of Chromium.
Each component keeps its own licence. The fork as a whole is distributed under
the GNU General Public License v3.0 (see `LICENSE`), because it includes code
from Helium under that licence.

| Component | Licence | Copyright holder | Where it appears |
|---|---|---|---|
| Chromium | BSD 3-Clause | The Chromium Authors (Google LLC) | Whole source tree, not in this repo. Full text in the Chromium source's `LICENSE`, and in the browser under `about:credits`. |
| ungoogled-chromium | BSD 3-Clause | The ungoogled-chromium Authors | `LICENSE.ungoogled_chromium` |
| Helium | GPL-3.0 | The Helium Authors (imput) | this repository and `helium-chromium/`, plus per-file headers. Upstream: https://github.com/imputnet/helium |
| Bundled !bangs list | MIT | Copyright (c) 2024 Kagi Search, 2026 imput | `resources/bangs.json` (licence text at the top of the file) |

## Fetched at build time, not stored in this repo

These are downloaded when the browser is built. They are not included in this
repository, and their licences need to be checked before a binary is
distributed:

- **Search engine data** (`nonfree-search-engines-data`), from
  https://github.com/imputnet/helium-nonfree-assets. Licence not confirmed.
- **Onboarding assets** (`nonfree-icons`) and the `@imput/helium-prism` npm
  package, used by `components/helium_onboarding`. Licence not confirmed.
- **uBlock Origin filter lists**, fetched at runtime from their publishers.
  Each list carries its own licence.

## Trademarks

"Chromium" and "Google Chrome" are trademarks of Google LLC. "Helium" is a
trademark of its authors. OmaBrowse is not affiliated with, endorsed by, or
sponsored by Google LLC, The Helium Authors, or imput. Names are used only to
credit upstream work.
