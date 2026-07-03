# Pre-existing bug: "Expected a Token" error when passing unrecognised biblatex style options

## Symptom

When a document loads biblatex with a style that doesn't match `authoryear|apa`, e.g.:

```latex
\usepackage[style=numeric]{biblatex}
```

LaTeXML emits:

```
Error:misdefined: Expected a Token, got  at biblatex.sty.ltxml; line 27
```

The error does not affect output — conversion completes and citations render correctly (falling back to `\cite`). Documents with `style=authoryear` or no `style` option do not trigger the error.

## Cause

The error comes from `ProcessOptions(inorder => 1, keysets => ['biblatex'])` (line 27) when processing the `style` key. The `DefKeyVal` declaration for `style` was added in commit `94a7b2e` on the `biblatex-authoryear-labels` branch. The exact trigger within LaTeXML's option processing internals is unclear — changing the type to `Semiverbatim` and the default to `undef` did not resolve it.

## Reproduction

```bash
cat > /tmp/test.tex << 'EOF'
\documentclass{article}
\usepackage[style=numeric]{biblatex}
\begin{document}
\cite{foo}
\end{document}
EOF
latexml --path=bindings test.tex 2>&1 | grep Error
```

## Possible fixes

- Investigate how LaTeXML's `ProcessOptions` + `DefKeyVal` interact when a key's `code` callback doesn't consume the value in all branches
- Try declaring `style` via `DeclareOption` instead of `DefKeyVal` to sidestep keyset processing
- Check whether newer LaTeXML versions handle this differently
