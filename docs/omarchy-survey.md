# Omarchy survey (Phase 0)

Findings for the Omarchy-native Helium patch set. Paths are in the pinned Chromium source
(`chromium-156.0.8078.47`), as unpacked and patched by `scripts/shared.sh`.

## Versions
- Repo HEAD: helium-linux `0.20.1.1` (commit `473c0f7`). Installed here: `helium-browser-bin 0.19.4.1-1` (Chromium 155). Rebase needs to target HEAD, not the installed build.
- Chromium pinned by `downloads.ini`: `156.0.8078.47`.

## Build environment gotcha
- `/mnt/data` is NTFS (`ntfs3`, `windows_names`). Chromium's sysroot contains filenames with `\`, which NTFS rejects, so unpacking fails there.
- Fix: the build tree lives on a btrfs volume outside the repo (`~/omabrowse-build`), and `helium-linux/build` is a symlink to it. The git repo can stay on NTFS.

## Findings from the pinned source

| Brief item | Location | Notes |
|---|---|---|
| Corner radius lookup | `ui/views/layout/layout_provider.cc:191` (`GetCornerRadiusMetric(Emphasis, Size)`) | Stock returns 0, 4, 8 for `kNone`, `kLow`/`kMedium`, `kHigh`; `kMaximum` returns half the shorter side. The token overload is at `:227`. |
| Chrome overrides | `chrome/browser/ui/views/chrome_layout_provider.{h,cc}` | Not yet read in full. Confirm whether it overrides the Emphasis or token overload. |
| Tab outline corners | `chrome/browser/ui/views/tabs/tab_style_views.{h,cc}` | No literal corner constants found by name search. Locate the radius token it uses in Phase 4. |
| Omnibox radius | `chrome/browser/ui/views/location_bar/location_bar_view.cc`, `omnibox_chip_button.cc`, `icon_label_bubble_view.cc`; `chrome/browser/ui/views/omnibox/omnibox_popup_view_browser_view.cc` | Several call sites. Hook the central lookup, not each one. |
| Theme service seed colour | `chrome/browser/themes/theme_service.h:208` (`SetUserColor`), `:217` (`SetUserColorAndBrowserColorVariant`), `:198` (`SetBrowserColorScheme`) | Virtual methods. This is what Customize Chrome uses. |
| Colour mixer | `chrome/browser/ui/color/chrome_color_mixer.cc`, `chrome_color_mixers.cc`, `material_chrome_color_mixer.cc`, `material_omnibox_color_mixer.cc`, `material_side_panel_color_mixer.cc`, `material_new_tab_page_color_mixer.cc` | Mixers map colour IDs; the Omarchy overlay mixer goes here. |
| Internal-page colour stylesheet | `chrome/browser/ui/webui/theme_source.cc` (`GenerateColorsCss` at `:272`, `SendColorsCss` at `:485`), `chrome/browser/ui/webui/theme_colors_source_manager.cc:35` (URL `chrome://theme/colors.css`) | Generated per profile. Pages refresh through `colors_css_updater.js`. Add `--omarchy-radius` here (Phase 5). |
| Internal-page radius variables | `ui/webui/resources/cr_elements/cr_shared_vars.css:191` (`--cr-card-border-radius: 8px`) | Point these at `var(--omarchy-radius)` with the stock values as fallback. |
| Process singleton | `chrome/browser/process_singleton.h:103` (`NotificationCallback(CommandLine, current_directory)`), `process_singleton_posix.cc` | A second launch hands its command line to the running browser here. Use it for `--omarchy-reload`. |

## Helium patches that touch the same ground
- `helium/linux/use-default-theme.patch`: on Linux, `GetDefaultSystemTheme()` always returns `SystemTheme::kDefault`, so GTK and Qt themes are ignored. Our colours therefore won't fight a system theme.
- `helium/linux/disable-tab-strokes.patch`: `BrowserView::ShouldDrawTabStrokes()` returns false on Linux. Tab outline work (Phase 4) must build on top of that.

## Open items for Phase 4-5
- Confirm which radius overload `ChromeLayoutProvider` overrides.
- Find the tab corner token in `tab_style_views.cc`.
- Read `theme_source.cc` `GenerateColorsCss` to see where the variables are emitted.

## Not yet done
- The unmodified `scripts/docker-build.sh` build (hours). Not started; waiting for approval.
