// Standalone checks for the pure parser. Build with:
//   clang++ -std=c++20 -Wall -Wextra -Werror -I. \
//     chrome/browser/omarchy/omarchy_theme_parse.cc \
//     tests/omarchy_theme_parse_test.cc -o parse_test
#include <cstdio>
#include <cstdlib>
#include <string>

#include "chrome/browser/omarchy/omarchy_theme_parse.h"

namespace {

int failures = 0;

#define EXPECT(cond)                                                   \
  do {                                                                 \
    if (!(cond)) {                                                     \
      std::fprintf(stderr, "%s:%d: FAILED: %s\n", __FILE__, __LINE__, \
                   #cond);                                             \
      ++failures;                                                      \
    }                                                                  \
  } while (0)

constexpr char kDarkToml[] =
    "mode = \"dark\"\n"
    "accent = \"#89b4fa\"\n"
    "background = \"#1e1e2e\"\n"
    "foreground = \"#cdd6f4\"\n"
    "dark_background = \"#161622\"\n";

constexpr char kLightToml[] =
    "mode = \"light\"\n"
    "background = \"#f4f1e8\"\n"
    "foreground = \"#2c2a26\"\n";

void TestDarkTheme() {
  auto theme = omarchy::ParseColorsToml(kDarkToml);
  EXPECT(theme.has_value());
  if (!theme) return;
  EXPECT(theme->dark);
  EXPECT(theme->colors.at("accent") == 0x89b4fa);
  EXPECT(theme->colors.at("background") == 0x1e1e2e);
  EXPECT(theme->colors.at("dark_background") == 0x161622);
  EXPECT(theme->colors.count("mode") == 0);
}

void TestLightTheme() {
  auto theme = omarchy::ParseColorsToml(kLightToml);
  EXPECT(theme.has_value());
  if (!theme) return;
  EXPECT(!theme->dark);
  EXPECT(theme->colors.at("foreground") == 0x2c2a26);
}

void TestMissingFile() {
  EXPECT(!omarchy::ParseColorsToml(""));
  EXPECT(!omarchy::ParseColorsToml("# only a comment\n[section]\n"));
}

void TestMalformedValues() {
  constexpr char kBad[] =
      "background = \"#12\"\n"
      "foreground = \"notacolour\"\n"
      "accent = \"#zz0000\"\n"
      "red = \"#f38ba8\"\n"
      "garbage line with no equals\n";
  auto theme = omarchy::ParseColorsToml(kBad);
  EXPECT(theme.has_value());
  if (!theme) return;
  // Only the valid entry survives; bad ones are skipped, not fatal.
  EXPECT(theme->colors.size() == 1);
  EXPECT(theme->colors.at("red") == 0xf38ba8);
}

void TestCrLfAndSingleQuotes() {
  auto theme = omarchy::ParseColorsToml("accent = '#89b4fa'\r\nmode = 'light'\r\n");
  EXPECT(theme.has_value());
  if (!theme) return;
  EXPECT(theme->colors.at("accent") == 0x89b4fa);
  EXPECT(!theme->dark);
}

void TestHexColor() {
  EXPECT(omarchy::ParseHexColor("#00ff7f") == 0x00ff7f);
  EXPECT(omarchy::ParseHexColor("#ABCDEF") == 0xabcdef);
  EXPECT(!omarchy::ParseHexColor("00ff7f"));
  EXPECT(!omarchy::ParseHexColor("#00ff7"));
  EXPECT(!omarchy::ParseHexColor("#00ff7g"));
}

void TestRoundingTheme() {
  constexpr char kTheme[] =
      "hl.config({\n"
      "  decoration = {\n"
      "    rounding = 6,\n"
      "    rounding_power = 3,\n"
      "  },\n"
      "})\n";
  EXPECT(omarchy::ParseRoundingLua(kTheme) == 6);
}

void TestRoundingCommentedOut() {
  constexpr char kUser[] =
      "-- hl.config({ decoration = { rounding = 8 } })\n"
      "--   rounding = 8,\n";
  EXPECT(!omarchy::ParseRoundingLua(kUser));
}

void TestRoundingLastWins() {
  // Theme sets 6, the user's looknfeel sets 12 later: the later value wins.
  constexpr char kTheme[] = "rounding = 6\n";
  constexpr char kUser[] = "rounding = 12\n";
  EXPECT(omarchy::ParseRoundingLua(std::string(kTheme) + kUser) == 12);
}

void TestRoundingClamped() {
  EXPECT(omarchy::ParseRoundingLua("rounding = 0\n") == 0);
  EXPECT(omarchy::ParseRoundingLua("rounding = 99\n") == omarchy::kMaxRadius);
  EXPECT(!omarchy::ParseRoundingLua("rounding = 99999\n"));  // Too long: skipped.
}

void TestRoundingMalformed() {
  EXPECT(!omarchy::ParseRoundingLua("rounding = \"six\"\n"));
  EXPECT(!omarchy::ParseRoundingLua("rounding = -4\n"));
  EXPECT(!omarchy::ParseRoundingLua("rounding =\n"));
  EXPECT(!omarchy::ParseRoundingLua("rounding_power = 3\n"));
  EXPECT(!omarchy::ParseRoundingLua(""));
}

}  // namespace

int main() {
  TestDarkTheme();
  TestLightTheme();
  TestMissingFile();
  TestMalformedValues();
  TestCrLfAndSingleQuotes();
  TestHexColor();
  TestRoundingTheme();
  TestRoundingCommentedOut();
  TestRoundingLastWins();
  TestRoundingClamped();
  TestRoundingMalformed();
  if (failures) {
    std::fprintf(stderr, "%d failure(s)\n", failures);
    return EXIT_FAILURE;
  }
  std::printf("all parser checks passed\n");
  return EXIT_SUCCESS;
}
