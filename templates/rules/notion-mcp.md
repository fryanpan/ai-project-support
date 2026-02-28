# Notion MCP Conventions

## Retry Behavior

`notion-update-page` and `notion-fetch` frequently fail on the first attempt and succeed immediately on retry. **Retry once before investigating.** This is a known MCP quirk, not an error in your request.

## Fetching Pages

Always use the **page ID** directly with `notion-fetch`, not the full Notion URL. Fetching by URL fails with an `invalid_type` error.

## Replacing Content

Prefer `replace_content_range` or `insert_content_after` over `replace_content` with `allow_deleting_content: true`. The latter archives child pages that were embedded in the old content — this is destructive and hard to undo.

When replacing content on a page that has child pages, preserve the `<page url="...">` tags in your new content to avoid archiving them.
