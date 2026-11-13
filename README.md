# Faculty Application Package: a LaTeX template

A complete, consistent LaTeX template for academic job applications. It
covers the **Cover Letter**, **Curriculum Vitae**, **Research Statement**,
**Teaching Dossier**, **EDIA Statement** and **References**. All six share
one class (`facultyapp.cls`), one look and one file of personal details.

Compile `main.tex`. Overleaf runs everything for you, including Biber.

## What it does for you

| | |
|---|---|
| **Enter details once** | Your name, contact details and the target position go in `config.tex`. The letterhead, letter address block, subject line, salutation, footers and PDF metadata are all generated from it. |
| **Tailor in minutes** | Write `\Institution`, `\Department`, `\PositionTitle`, … in your letter and statements. For the next application, change one block in `config.tex`. |
| **One PDF or many** | Build the full package, with a cover page, linked contents and PDF bookmarks, or any single document for portals that want separate uploads (one `\includeonly` line). |
| **Pages that can't get lost** | Every page carries your name, the document title and “Page X of Y”, and numbering restarts in each document. |
| **Publications from BibTeX** | Lists are generated from `publications.bib`, newest first, numbered in reverse (`[J12]` … `[J1]`) and grouped by type. Your name is bold. Trainee, equal-contribution and corresponding-author marks are supported, titles link to the DOI, and awards get a trophy icon. |
| **Citations that match your CV** | `\cite{key}` in any document prints the label the CV gives that publication (`[J5]`, `[C3]`) and links to the entry, so committees can check every claim against your record. |
| **Teaching evidence that reads at a glance** | Key-number tiles, rating bars against department means, student quotations, page-breaking data tables, and a local table of contents. |
| **Page limits** | `page limit = 2` on a document warns you in the log, and also in the PDF while tips are on, if it runs over. |
| **Built-in writing guidance** | The `tips` option shows research-based advice boxes in the PDF. Remove the option and they disappear. |
| **Accessible output** | Real text, a PDF language tag, document title metadata and a bookmark outline. All built-in colours meet WCAG AA contrast (at least 4.5:1). |

## Quick start

1. **`config.tex`**: your details, the position, and your name as it
   appears in your publications.
2. **`documents/*.tex`**: write the six documents. The sample text
   (a fictional applicant) shows what strong content looks like.
3. **`publications.bib`**: paste your publications (Google Scholar,
   Zotero, ORCID or any other BibTeX export).
4. Before you submit, delete `tips` from the `\documentclass` options in
   `main.tex`.

## Files

```
main.tex                 compile this; class options and document list
config.tex               your details + the position
publications.bib         your publications (feeds the CV)
facultyapp.cls           the class (no need to edit)
documents/
  cover-letter.tex
  cv.tex
  research-statement.tex
  teaching-dossier.tex
  edia-statement.tex
  references.tex
```

## Class options (in `main.tex`)

| Option | Values | Default |
|---|---|---|
| paper | `letterpaper`, `a4paper` | `letterpaper` |
| size | `10pt`, `11pt`, `12pt` | `11pt` |
| `font` | `charter`, `libertinus`, `palatino`, `sourcesans`, `lmodern`, `none` | `charter` |
| `accent` | `navy`, `teal`, `burgundy`, `forest`, `slate`, `plum`, `ochre`, `black`, or any xcolor colour (`blue!60!black`) | `navy` |
| `header` | `split`, `centered` | `split` |
| `language` | any babel language (`canadian`, `british`, `french`, …) | `english` |
| `tips` | show writing tips | off |
| `margin` | any length | `2.2cm` |

`accent`, `margin`, `cv label width` and `publication numbering`
(`descending` | `ascending` | `none`) can also be changed later with
`\facultyappsetup{...}`.

## Common tasks

**Separate PDFs.** In `main.tex`, uncomment one line such as
`\includeonly{documents/cv}`, recompile and download. Comment it out again
afterwards. The cover page is skipped automatically.

**Rename the EDIA statement.** Put the posting's wording in the title in
`documents/edia-statement.tex`, e.g.
`{Statement on Equity, Diversity and Inclusion}`. `short = {...}` sets the
name used in footers and on the cover page.

**Add a document** (e.g. a statement of service). Copy
`documents/edia-statement.tex`, change the title, and add
`\include{documents/service-statement}` in `main.tex`. It automatically
gets the letterhead, footers, bookmarks, a cover-page entry and an
enclosure-list entry.

**Remove a document.** Delete its `\include` line in `main.tex`. The cover
page and the letter's enclosure list update on the next compile.

**Document options.**
`\begin{applicationdocument}[short=..., subtitle=..., page limit=2, contents, numbered, ragged]{Title}`

**Cover letter options.**
`\begin{coverletter}[date=..., closing=..., subject=auto|none|text, enclosures=auto|none|text, page limit=2]`

## Building blocks

```latex
% CV
\cventry{2019--2024}{Ph.D., Biology}{University X}{City}{Details...}
\cvitem{2025}{Best Paper Award, ...}
\cvnote{Amounts in CAD.}
\publist[J]{Journal articles}{type=article}       % any \printbibliography filter
\publicationlegend                                % explains the marks

% Research statement (or any document)
\cite{ellis2025hybrid}                  % -> [J5], linked to the CV entry
\cite{ellis2025hybrid,ellis2022physics} % -> [J5, C1]
\begin{figure}[htb] ... \caption{...} \end{figure}   % styled captions

% Teaching dossier
\begin{keystats}[4] \keystat{450+}{students taught} ... \end{keystats}
\ratingbar[4.1]{4.6}{5}   \ratinglegend           % score 4.6 of 5, comparison mean 4.1
\studentquote[ENVS 220, Winter 2023]{Quotation...}
\begin{datatable}{l X r} \colhead{Term} & ... \\ \midrule\endhead ... \bottomrule \end{datatable}

% References
\begin{referees}[2]
  \referee{name=..., title=..., department=..., institution=..., address=...,
           email=..., phone=..., relationship=..., note=...}
\end{referees}

% Writing tips (shown only with the `tips' option)
\tip[Heading]{Advice...}
```

**Publication marks** in `publications.bib`:

```bibtex
author+an = {2=trainee},            % dagger
author+an = {1=equal; 2=equal},     % asterisk
author+an = {1=corresponding},      % double dagger
award     = {Best Paper Award},     % trophy
keywords  = {preprint},             % for keyword=preprint filters
```

## Troubleshooting

- **“??” in page counts, or “Compile once more” on the cover page.**
  Recompile. Page totals and the contents come from the previous pass.
  Overleaf normally does this automatically.
- **Publications missing.** The bibliography backend must be Biber, which
  is Overleaf's default. Check that the entries are in `publications.bib`.
- **`??` instead of a citation label.** Recompile. The label is taken from
  the CV, so the cited entry must appear in one of its `\publist` lists.
- **Your name is not bold.** Add the exact spelling used in the `.bib`
  file: `\highlightauthor{Family}{Given}`.
- **Special characters.** Escape `& % _ #` as `\& \% \_ \#`.
- **Engines.** pdfLaTeX (Overleaf's default), XeLaTeX and LuaLaTeX all work.

## License

`facultyapp.cls` is released under the LaTeX Project Public License 1.3c.
All other files (sample text, configuration and example data) are released
under CC0 1.0: use them however you like, no attribution needed. The
applicant, institutions, people, publications and DOIs in the sample are
fictional.
