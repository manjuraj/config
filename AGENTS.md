## Writing Guidelines

Use Hemingway-inspired guidelines for writing. Treat these as guidance, not hard
rules:
- Use short sentences.
- Use short first paragraphs.
- Use vigorous English.
- Avoid unnecessary adjectives.
- Eliminate every superfluous word.
- Avoid em-dashes whenever possible. Prefer a period, comma, or parentheses.
- Write enumeration bullets as clean fragments, with no trailing commas and no
  final period, even after a lead-in colon. Use a period per bullet only when
  each bullet is a complete sentence.

## Markdown Guidelines

Wrap prose at about 80 columns.

Do not hard-wrap tables, URLs, code blocks, headings, or generated snippets.

Refer to `$HOME/Development/Mad-Labs/agent-references/MERMAID.md` when creating
or changing Mermaid diagrams in Markdown.

## HTML Artifact Guidelines

Refer to
`$HOME/Development/Mad-Labs/agent-references/html-artifact-guidelines.md` when
creating or changing human-facing HTML artifacts.

## Serde Guidelines

Refer to `$HOME/Development/Mad-Labs/agent-references/SERDE.md` when designing or
changing Serde serialization and deserialization in Rust projects.

## Development Environment

If a repository contains a `.envrc`, treat `direnv exec . ...` as the default
way to run all repo-local commands.

A repository's `.envrc` may place Nix-provided tools on `PATH`. Inspect the
active environment when command behavior matters. Do not assume macOS/BSD or
GNU semantics unless the repository declares the relevant tool.

Run those commands from the repository root so the correct toolchain,
environment variables, and dependencies are loaded.

Do not invoke repo-local tools directly unless the user explicitly asks to
bypass `direnv`.

When a Nix-backed command fails because the process cannot access the Nix
daemon socket, treat it as a local permission boundary rather than a project
failure. Retry the same command with the narrowest available permission scope
that lets it access the daemon. Keep the command itself unchanged unless the
user asks for a different toolchain path.

Warnings about a dirty flake or environment checkout are informational unless
the command exits non-zero.

## Git Commit Guidelines

Refer to `$HOME/Development/Mad-Labs/agent-references/git-commit-guidelines.md` when
writing git commit messages.

Never add a `Co-Authored-By` trailer, or any co-authoring attribution, to
commit messages.
