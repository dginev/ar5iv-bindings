# Response to review of PR #21: biblatex author-year labels

Thanks for the thorough (Claude-generated) review! Below is our analysis and proposed fixes for each issue.

## Change Summary

| Issue | Status | Fix complexity |
|-------|--------|---------------|
| 1. Missing optional arg | Confirmed | One-line |
| 2. Dead code | Resolved by #7 | No separate fix needed |
| 3. Identical authors/fullauthors | Confirmed | ~10 lines |
| 4. Suffix regex | Confirmed | One character |
| 5. Double Digest(Expand()) | Confirmed | Small refactor |
| 6. Unused suffix keyval | Confirmed | One line |
| 7. printbibliography change | Regression, easy fix | Fallback to old path |

## Blocking Issues

### Issue 1: `\printbibliography` no longer consumes its optional argument

**Status:** Confirmed

The old code delegated to `\biblatex@printbibliography[]` which consumed the optional `[]` argument. Our replacement has no argument spec, so `\printbibliography[heading=bibintoc]` will leak literal text.

**Fix applied:** Added `[]` to the argument spec at line 472 to consume and discard the optional argument. `\printbibliography[heading=bibintoc]` will now correctly ignore the option instead of leaking it as literal text.

---

### Issue 2: `\biblatex@printbibliography` is now dead code

**Status:** Mooted by issue 7 fix

The old `\printbibliography` expanded to `\biblatex@printbibliography`. Our new version bypasses it entirely, making it dead code. However, the fix for issue 7 restores it as the fallback when no `.bbl` file exists, so it is no longer dead code.

---

### Issue 3: `authors` and `fullauthors` tags are always identical

**Status:** Confirmed

Both tags receive the same `$author_part` string (lines 218-219). The `fullauthors` tag should list all author surnames, while `authors` can be truncated ("Smith et al.").

**Fix applied:** Added computation of `$full_author_part` from the full `@names` array (lines 215-226). For 1-2 authors, all surnames are joined with `&`; for 3+, surnames are comma-separated with `&` before the last. Falls back to `$author_part` when no name data is available. The `authors` tag keeps the short form (e.g. "Smith et al."), while `fullauthors` now lists all surnames (e.g. "Smith, Jones & Brown").

---

## Non-blocking Issues

### Issue 4: Disambiguation suffix regex too restrictive

**Status:** Confirmed

Line 208: `\w?` only matches zero or one suffix character. The existing disambiguation logic (lines 186-193) explicitly handles multi-character suffixes like `aa`, `ab`, etc.

**Fix applied:** Changed `\w?` to `\w*` at line 208 to match multi-character disambiguation suffixes like `aa`, `ab`.

---

### Issue 5: Year is `Digest(Expand(...))`-ed twice

**Status:** Confirmed

The year is computed once at line 162 (in the label-generation block) and again at line 206 (in the structured-tags block). `Digest(Expand(...))` is not free.

**Fix applied:** Hoisted `$year_tok` / `$year_str` computation to line 157-158, before both the label-generation and structured-tags blocks. Removed the duplicate at the old line 205-206. Both blocks now reference the same `$year_str`.

---

### Issue 6: `suffix`/`suffixi` keyvals defined but never consumed

**Status:** Confirmed

The keyvals are defined at lines 326-327, but the name-construction code at lines 364-368 only reads `given`/`prefix`/`family`. Names like "Martin Luther King Jr." will lose the suffix.

**Fix applied:** Added `$kv_suffix` extraction at line 378 and included it in the `$fullname` join at line 380. Names like "Martin Luther King Jr." will now retain their suffix.

---

### Issue 7: `\printbibliography` behavioral change

**Status:** Confirmed regression, easy fix

The change to `\InputIfFileExists{\jobname.bbl}` is correct for biber workflows (which always produce a `.bbl`), but it regresses the case where only `.bib` files are available and no `.bbl` was generated. In that case the old code fell back to LaTeXML's `\bibliography` machinery via `\biblatex@printbibliography`, but our code silently produces no bibliography.

**Fix applied:** Changed the "else" branch of `\InputIfFileExists` at line 475 to fall back to `\biblatex@printbibliography`, which processes `\addbibresource` declarations via LaTeXML's bibliography machinery. This tries the `.bbl` first (for biber/author-year workflows), and falls back to the old resource-based approach if no `.bbl` exists. This also resolves issue 2 — `\biblatex@printbibliography` is no longer dead code. The `\catcode` handling for `&` is needed because `&` appears literally in author names in `.bbl` files.
