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
`$HOME/Development/Mad-Labs/agent-references/HTML.md` when
creating or changing human-facing HTML artifacts.

## Development Environment

If a repository contains a `.envrc`, use its environment for repo-local commands.

For non-interactive commands, execute from the repository root with
`direnv exec . <command>`.

For commands the user runs in an interactive shell where direnv is already
loaded, show `<command>` directly.

## Git Commit Guidelines

Refer to `$HOME/Development/Mad-Labs/agent-references/GIT-COMMIT.md` when writing
git commit messages.

## Git Worktree Guidelines

Refer to `$HOME/Development/Mad-Labs/agent-references/GIT-WORKTREE.md` when
creating, moving, repairing, or removing Git worktrees.
