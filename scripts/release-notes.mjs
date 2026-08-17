#!/usr/bin/env node
// Release notes extraction (mirrors opencoder scripts/release-notes.mjs).
// Reads the version's section from the changelog and writes it to a file used
// as the GitHub Release body:
//   node scripts/release-notes.mjs <version> [--out release-notes.md]
//     [--changelog CHANGELOG.md]
// The exact "## [<version>]" section is used when present; otherwise the
// "[Unreleased]" section is used as the pre-release fallback. Exits 1 when
// neither section exists.

import { readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const ROOT = resolve(import.meta.dirname, "..");
const args = process.argv.slice(2);
const version = args[0]?.replace(/^v/, "");

function opt(name) {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : undefined;
}

const out = opt("--out");
const changelogPath = opt("--changelog") ?? "CHANGELOG.md";

if (!version) {
  process.stderr.write(
    "usage: node scripts/release-notes.mjs <version> [--out file] [--changelog file]\n",
  );
  process.exit(2);
}

let source;
try {
  source = readFileSync(resolve(ROOT, changelogPath), "utf8");
} catch {
  process.stderr.write(`release-notes: cannot read ${changelogPath}\n`);
  process.exit(1);
}
const lines = source.split("\n");
const isHeading = (line) => /^##\s+/.test(line);
const sectionStart = lines.findIndex((line) => {
  const match = /^##\s+\[([^\]]+)\]/.exec(line);
  return match && match[1] === version;
});

let start = sectionStart;
let label = `## [${version}]`;
if (start < 0) {
  const unreleased = lines.findIndex((line) => /^##\s+\[Unreleased\]/.test(line));
  if (unreleased < 0) {
    process.stderr.write(
      `release-notes: no "## [${version}]" or "## [Unreleased]" section in ${changelogPath}\n`,
    );
    process.exit(1);
  }
  start = unreleased;
  label = "## [Unreleased]";
  process.stderr.write(
    `release-notes: no "## [${version}]" section in ${changelogPath}, using [Unreleased] fallback\n`,
  );
}

let end = lines.length;
for (let i = start + 1; i < lines.length; i++) {
  if (isHeading(lines[i])) {
    end = i;
    break;
  }
}

const body = lines
  .slice(start + 1, end)
  .join("\n")
  .trim();
if (!body) {
  process.stderr.write(`release-notes: section ${label} is empty\n`);
  process.exit(1);
}

const notes = `${label}\n\n${body}\n`;
if (out) {
  writeFileSync(resolve(ROOT, out), notes);
  process.stdout.write(`release-notes: wrote ${out} (${label})\n`);
} else {
  process.stdout.write(notes);
}
