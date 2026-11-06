# OmaBrowse

OmaBrowse is a privacy- and security-focused web browser for Omarchy, built as
a fork of [Helium](https://github.com/imputnet/helium), which is itself a
patched build of [Chromium](https://www.chromium.org/).

OmaBrowse is built so that it does not contact Helium's servers. Features that need a network
service connect directly to the provider of that service (for example, the
Chrome Web Store for extensions), and each one can be turned off in settings.
A self-hosted services instance can be set in settings, and it is optional.

## Licence

OmaBrowse is distributed under the GNU General Public License v3.0. See
[`LICENSE`](LICENSE). Third-party components keep their own licences, listed in
[`NOTICE.md`](NOTICE.md).

## Credits

- Chromium, by The Chromium Authors and Google LLC.
- ungoogled-chromium, by The ungoogled-chromium Authors.
- Helium, by The Helium Authors (imput).

## Disclaimer

OmaBrowse is not affiliated with, endorsed by, or sponsored by Google LLC,
The Helium Authors, imput, or the Omarchy project. The name refers to the
desktop it is built for. It is provided as is, without warranty of any kind.
