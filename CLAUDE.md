# newxp

Elixir hex package providing HTML cleaning and general string processing utilities. The primary module is `Newxp.PreProcessing`, which uses [Floki](https://github.com/philss/floki) to parse and transform HTML documents — removing unwanted elements and normalizing content for downstream processing.

## Testing

All new functions must follow TDD:

1. **Red** — write the failing test first
2. **Green** — write the minimum implementation to pass it
3. **Refactor** — clean up without breaking the test

No function should be added without a corresponding test in `test/newxp/`.
