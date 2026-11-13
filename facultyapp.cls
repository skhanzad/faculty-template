%% =====================================================================
%%  facultyapp.cls  --  A complete faculty application package for LaTeX
%% =====================================================================
%%
%%  One class, one look, six documents:
%%    Cover Letter . Curriculum Vitae . Research Statement .
%%    Teaching Dossier . EDIA Statement . References
%%
%%  Features
%%    * Enter your details and the target position ONCE (config.tex);
%%      every document picks them up (\Institution, \PositionTitle, ...).
%%    * Full package as one PDF with cover page, linked contents and
%%      PDF bookmarks -- or any single document via \includeonly.
%%    * Per-document "Page X of Y" footers carrying your name, so pages
%%      can never get lost when a committee prints and shuffles them.
%%    * Publications typeset straight from a .bib file: your name in bold,
%%      trainee / equal-contribution / corresponding-author marks,
%%      reverse numbering ([J12] ... [J1]), linked titles, awards.
%%    * \cite{key} in any document prints the CV's label ([J5]) and
%%      links to the entry in the CV.
%%    * Teaching dossier helpers: key-number tiles, rating bars,
%%      student quotations, data tables, local table of contents.
%%    * Optional page limits per document with warnings.
%%    * Writing tips that show in the PDF while drafting (`tips' option)
%%      and vanish for the final version.
%%
%%  Works with pdfLaTeX (Overleaf default), XeLaTeX and LuaLaTeX + Biber.
%%
%%  Author: Sourena Khanzadeh
%%  Copyright (c) 2026 Sourena Khanzadeh
%%
%%  This work may be distributed and/or modified under the conditions of
%%  the LaTeX Project Public License, version 1.3c or later:
%%  https://www.latex-project.org/lppl.txt
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{facultyapp}[2026/11/12 v1.0 Faculty application package]

\RequirePackage{etoolbox}
\RequirePackage{pgfopts}

%% ---------------------------------------------------------------------
%%  1. Options (usable in \documentclass[...] and in \facultyappsetup{...})
%% ---------------------------------------------------------------------
\newif\iffa@tips
\def\fa@paper{letterpaper}
\def\fa@ptsize{11pt}
\def\fa@font{charter}
\def\fa@language{english}
\def\fa@accentname{navy}
\def\fa@header{split}
\def\fa@margin{2.2cm}
\def\fa@cvlabelwidthval{2.1cm}
\def\fa@pubnumbering{descending}
\let\fa@updategeometry\relax
\let\fa@applyaccent\relax

\newcommand\fa@classonly[2]{%
  \ifdefined\fa@classloaded
    \ClassWarning{facultyapp}{Option `#1' only works in \string\documentclass[...]}%
  \else #2\fi}

\pgfkeys{
  /facultyapp/.cd,
  % --- paper and size -------------------------------------------------
  letterpaper/.code = {\def\fa@paper{letterpaper}\fa@updategeometry},
  a4paper/.code     = {\def\fa@paper{a4paper}\fa@updategeometry},
  paper/.code       = {\def\fa@paper{#1paper}\fa@updategeometry},
  margin/.code      = {\def\fa@margin{#1}\fa@updategeometry},
  10pt/.code = {\fa@classonly{10pt}{\def\fa@ptsize{10pt}}},
  11pt/.code = {\fa@classonly{11pt}{\def\fa@ptsize{11pt}}},
  12pt/.code = {\fa@classonly{12pt}{\def\fa@ptsize{12pt}}},
  % --- look ------------------------------------------------------------
  font/.code     = {\fa@classonly{font}{\def\fa@font{#1}}},
  language/.code = {\fa@classonly{language}{\def\fa@language{#1}}},
  accent/.code   = {\def\fa@accentname{#1}\fa@applyaccent},
  header/.is choice,
  header/split/.code    = {\def\fa@header{split}},
  header/centered/.code = {\def\fa@header{centered}},
  header/centred/.code  = {\def\fa@header{centered}},
  % --- behaviour -------------------------------------------------------
  tips/.is if  = fa@tips,
  final/.code  = {\fa@tipsfalse},
  cv label width/.code = {%
    \def\fa@cvlabelwidthval{#1}%
    \ifdefined\fa@cvlabelwidth\setlength\fa@cvlabelwidth{#1}\fi},
  publication numbering/.is choice,
  publication numbering/descending/.code = {\def\fa@pubnumbering{descending}},
  publication numbering/ascending/.code  = {\def\fa@pubnumbering{ascending}},
  publication numbering/none/.code       = {\def\fa@pubnumbering{none}},
  .unknown/.code = {%
    \ClassWarning{facultyapp}{Unknown option `\pgfkeyscurrentname' ignored}},
}
\ProcessPgfOptions{/facultyapp}
\RequirePackage{fix-cm}% scalable Computer Modern for math at any size
\edef\fa@tmp{\noexpand\LoadClass[\fa@ptsize,\fa@paper]{article}}
\fa@tmp
\def\fa@classloaded{}
\newcommand\facultyappsetup[1]{\pgfkeys{/facultyapp/.cd,#1}}

%% ---------------------------------------------------------------------
%%  2. Engine, fonts and language
%% ---------------------------------------------------------------------
\RequirePackage{iftex}
\iftutex\else
  \RequirePackage[T1]{fontenc}
\fi

\@namedef{fa@font@charter}{%
  \RequirePackage[lining]{XCharter}%
  \RequirePackage[semibold,scale=0.95]{sourcesanspro}}
\@namedef{fa@font@libertinus}{%
  \RequirePackage{libertinus}}
\@namedef{fa@font@palatino}{%
  \RequirePackage{newpxtext}%
  \RequirePackage[semibold,scale=0.93]{sourcesanspro}}
\@namedef{fa@font@sourcesans}{%
  \RequirePackage[default,semibold]{sourcesanspro}}
\@namedef{fa@font@lmodern}{%
  \RequirePackage{lmodern}}
\@namedef{fa@font@none}{}
\ifcsname fa@font@\fa@font\endcsname
  \csname fa@font@\fa@font\endcsname
\else
  \ClassWarningNoLine{facultyapp}{Unknown font `\fa@font'; using charter}%
  \csname fa@font@charter\endcsname
\fi

\edef\fa@tmp{\noexpand\RequirePackage[\fa@language]{babel}}
\fa@tmp
\RequirePackage{csquotes}
\RequirePackage{microtype}
\RequirePackage{xspace}

%% ---------------------------------------------------------------------
%%  3. Colours
%% ---------------------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{fa@preset@navy}{HTML}{1F3A5F}
\definecolor{fa@preset@teal}{HTML}{0B6466}
\definecolor{fa@preset@burgundy}{HTML}{8A1C3B}
\definecolor{fa@preset@forest}{HTML}{2E5A3A}
\definecolor{fa@preset@slate}{HTML}{3B4856}
\definecolor{fa@preset@plum}{HTML}{5A2A6B}
\definecolor{fa@preset@ochre}{HTML}{8A5A00}
\definecolor{fa@preset@black}{HTML}{1A1A1A}
\colorlet{fa@ink}{black!88}
\colorlet{fa@muted}{black!64}
\colorlet{fa@rule}{black!22}
\colorlet{fa@alert}{red!70!black}
\def\fa@applyaccent{%
  \@ifundefinedcolor{fa@preset@\fa@accentname}
    {\colorlet{accent}{\fa@accentname}}%
    {\colorlet{accent}{fa@preset@\fa@accentname}}}
\fa@applyaccent

%% ---------------------------------------------------------------------
%%  4. Page geometry
%% ---------------------------------------------------------------------
\RequirePackage{geometry}
\def\fa@updategeometry{%
  \edef\fa@tmp{\noexpand\geometry{\fa@paper,margin=\fa@margin,
    footskip=0.85cm,headheight=16pt,headsep=0.4cm}}%
  \fa@tmp}
\fa@updategeometry

\RequirePackage[skip=6pt plus 2pt minus 1pt]{parskip}
\RequirePackage{graphicx}
\RequirePackage{array,tabularx,booktabs,xltabular}
\RequirePackage{ragged2e}
\RequirePackage{enumitem}
\RequirePackage{tikz}
\usetikzlibrary{arrows.meta,calc,positioning}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable,raster}
\RequirePackage{fontawesome5}
\RequirePackage{zref-user,zref-abspage}
\RequirePackage{titlesec}
\RequirePackage{caption}
\RequirePackage{fancyhdr}
\RequirePackage{etoc}

%% ---------------------------------------------------------------------
%%  5. Applicant, position and other stored data
%% ---------------------------------------------------------------------
%  \fa@definestorekeys{<key path>}{<macro prefix>}{<k1>,<k2>,...}
\def\fa@definestorekeys#1#2#3{%
  \@for\fa@tmpkey:=#3\do{%
    \expandafter\fa@definestorekey\expandafter{\fa@tmpkey}{#1}{#2}}}
\def\fa@definestorekey#1#2#3{%
  \expandafter\gdef\csname #3@#1\endcsname{}%
  \pgfkeys{#2/#1/.code=\expandafter\gdef\csname #3@#1\endcsname{##1}}}

\fa@definestorekeys{/facultyapp/applicant}{fa@app}{%
name,credentials,pronouns,position,department,institution,address,%
email,phone,website,orcid,scholar,github,linkedin,signature}
\pgfkeys{/facultyapp/applicant/.unknown/.code={%
  \ClassWarning{facultyapp}{Unknown \string\applicant\space key `\pgfkeyscurrentname'}}}

\fa@definestorekeys{/facultyapp/position}{fa@pos}{%
title,field,department,faculty,institution,address,reference,%
recipient,recipient title,salutation}
\pgfkeys{/facultyapp/position/.unknown/.code={%
  \ClassWarning{facultyapp}{Unknown \string\position\space key `\pgfkeyscurrentname'}}}

\newcommand\applicant[1]{\pgfkeys{/facultyapp/applicant/.cd,#1}}
\newcommand\position[1]{\pgfkeys{/facultyapp/position/.cd,#1}}

% expandable getters and tests
\newcommand*\fa@app[1]{\csname fa@app@#1\endcsname}
\newcommand*\fa@pos[1]{\csname fa@pos@#1\endcsname}
\newcommand*\fa@ifset[1]{%
  \expandafter\ifx\csname #1\endcsname\@empty
    \expandafter\@secondoftwo
  \else
    \expandafter\@firstoftwo
  \fi}
\newcommand*\fa@ifapp[1]{\fa@ifset{fa@app@#1}}
\newcommand*\fa@ifpos[1]{\fa@ifset{fa@pos@#1}}

% user-level accessors -- use them in your letters and statements
\newcommand\ApplicantName{\fa@app{name}\xspace}
\newcommand\PositionTitle{\fa@pos{title}\xspace}
\newcommand\PositionField{\fa@pos{field}\xspace}
\newcommand\Department{\fa@pos{department}\xspace}
\newcommand\Faculty{\fa@pos{faculty}\xspace}
\newcommand\Institution{\fa@pos{institution}\xspace}
\newcommand\JobReference{\fa@pos{reference}\xspace}
\newcommand\Recipient{\fa@pos{recipient}\xspace}
\newcommand\PositionSummary{%
  \fa@pos{title}\fa@ifpos{field}{ in \fa@pos{field}}{}%
  \fa@ifpos{institution}{, \fa@pos{institution}}{}\xspace}

% words used by the class (redefine to translate)
\newcommand\facultyappPageName{Page}
\newcommand\facultyappOfName{of}
\newcommand\facultyappCoverKicker{Application for the position of}
\newcommand\facultyappSubmittedBy{Submitted by}
\newcommand\facultyappContentsName{Contents of this application}
\newcommand\facultyappReferenceName{Reference no.}
\newcommand\facultyappEnclosuresName{Enclosures}
\newcommand\facultyappCoverLetterName{Cover Letter}
\newcommand\facultyappSubjectPrefix{Re:}

%% ---------------------------------------------------------------------
%%  6. Typography: fonts for the various elements
%% ---------------------------------------------------------------------
\newcommand\fa@sep{\hspace{0.55em}\textperiodcentered\hspace{0.55em}}
\newcommand\fa@namefont{\sffamily\bfseries\fontsize{23}{27}\selectfont\color{accent}}
\newcommand\fa@metafont{\sffamily\small\color{fa@muted}}
\newcommand\fa@contactfont{\sffamily\small\color{fa@ink}}
\newcommand\fa@doctitlefont{\sffamily\bfseries\fontsize{16}{19}\selectfont\color{accent}}
\newcommand\fa@footerfont{\sffamily\footnotesize\color{fa@muted}}
\newcommand\fa@labelfont{\sffamily\small\color{fa@muted}}
\newcommand\fa@entrytitlefont{\sffamily\bfseries\color{fa@ink}}
\newcommand\fa@orgfont{\itshape}
\newcommand\fa@detailfont{\small}

\setlist{topsep=3pt,partopsep=0pt,itemsep=2pt,parsep=0pt}
\setlist[itemize]{leftmargin=1.25em,
  label={\color{accent}\raisebox{0.1ex}{\footnotesize\textbullet}}}
\setlist[itemize,2]{label={\color{accent}\textendash}}
\setlist[enumerate]{leftmargin=1.6em}

% figure and table captions
\DeclareCaptionFont{fa@accent}{\color{accent}}
\captionsetup{font=small,labelfont={sf,bf,fa@accent},labelsep=period,skip=6pt}

%% ---------------------------------------------------------------------
%%  7. Section headings
%% ---------------------------------------------------------------------
\newcommand\fa@sectionfill[1]{%
  #1\nobreak\hspace{0.65em}%
  {\color{fa@rule}\leaders\hrule height \dimexpr0.5ex+0.3pt\relax
    depth \dimexpr-0.5ex+0.3pt\relax\hfill}}
\titleformat{\section}[hang]
  {\sffamily\bfseries\large\color{accent}}
  {\thesection}{0.6em}{\fa@sectionfill}
\titleformat{\subsection}
  {\sffamily\bfseries\normalsize\color{fa@ink}}
  {\thesubsection}{0.5em}{}
\titleformat{\subsubsection}[runin]
  {\normalfont\itshape}
  {\thesubsubsection}{0.5em}{}[.\quad]
\titlespacing*{\section}{0pt}{12pt plus 3pt minus 2pt}{4pt plus 1pt}
\titlespacing*{\subsection}{0pt}{9pt plus 2pt minus 1pt}{1pt}
\titlespacing*{\subsubsection}{0pt}{4pt plus 1pt}{0pt}

% A heading needs room for a few lines below it; otherwise it starts a new
% page. This keeps headings with the tables and boxes that follow them.
\newcommand\fa@needspace[1]{%
  \par
  \begingroup
    \setlength\dimen@{#1}%
    \dimen@ii\pagegoal\advance\dimen@ii-\pagetotal
    \ifdim\dimen@>\dimen@ii\ifdim\dimen@ii>\z@\vfil\fi\break\fi
  \endgroup}
\pretocmd{\section}{\fa@needspace{5\baselineskip}}{}{}
\pretocmd{\subsection}{\fa@needspace{4\baselineskip}}{}{}

%% ---------------------------------------------------------------------
%%  8. Page styles
%% ---------------------------------------------------------------------
\def\fa@doc@id{0}
\def\fa@doc@title{}
\def\fa@doc@short{}
\def\fa@doc@subtitle{}
\def\fa@doc@limit{}
\def\fa@doc@pages{}
\def\fa@doc@tocdepth{section}
\def\fa@doc@overlimit{}

\newcommand\fa@footerleft{{\fa@footerfont
  \fa@app{name}\ifx\fa@doc@short\@empty\else\fa@sep\fa@doc@short\fi}}
\newcommand\fa@footerright{{\fa@footerfont
  \facultyappPageName~\thepage
  \ifx\fa@doc@pages\@empty\else~\facultyappOfName~\fa@doc@pages\fi}}
\newcommand\fa@footercenter{%
  \iffa@tips\ifx\fa@doc@overlimit\@empty\else
    {\sffamily\footnotesize\bfseries\color{fa@alert}%
     \faExclamationTriangle\ \fa@doc@pages\ pages -- limit is \fa@doc@limit}%
  \fi\fi}
\newcommand\fa@tipsbadge{%
  \iffa@tips{\sffamily\scriptsize\color{fa@alert}%
    \faLightbulb[regular]\ Writing tips are visible -- remove the
    \texttt{tips} class option before you submit}\fi}

\fancypagestyle{facultyapp}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}%
  \fancyhead[R]{\fa@tipsbadge}%
  \fancyfoot[L]{\fa@footerleft}%
  \fancyfoot[C]{\fa@footercenter}%
  \fancyfoot[R]{\fa@footerright}}
\pagestyle{facultyapp}

%% ---------------------------------------------------------------------
%%  9. Contact details and letterheads
%% ---------------------------------------------------------------------
\def\fa@weburl{}
% \fa@forcontacts\handler  calls  \handler{<icon>}{<text>}{<url or empty>}
\newcommand\fa@forcontacts[1]{%
  \fa@ifapp{email}{#1{\faEnvelope}{\fa@app{email}}{mailto:\fa@app{email}}}{}%
  \fa@ifapp{phone}{#1{\faPhone}{\fa@app{phone}}{}}{}%
  \fa@ifapp{website}{#1{\faGlobe}{\fa@app{website}}{\fa@weburl}}{}%
  \fa@ifapp{orcid}{#1{\faOrcid}{\fa@app{orcid}}{https://orcid.org/\fa@app{orcid}}}{}%
  \fa@ifapp{scholar}{#1{\faGraduationCap}{Google Scholar}{\fa@app{scholar}}}{}%
  \fa@ifapp{github}{#1{\faGithub}{\fa@app{github}}{https://github.com/\fa@app{github}}}{}%
  \fa@ifapp{linkedin}{#1{\faLinkedin}{\fa@app{linkedin}}{https://www.linkedin.com/in/\fa@app{linkedin}}}{}%
  \fa@ifapp{address}{#1{\faMapMarker*}{\fa@app{address}}{}}{}}

\newcommand\fa@maybelink[2]{% {url}{text}
  \ifblank{#1}{#2}{\href{#1}{#2}}}
\newcommand\fa@contact@stacked[3]{%
  {\hypersetup{urlcolor=fa@ink}\fa@maybelink{#3}{#2}}%
  \hspace{0.5em}\makebox[1.05em][c]{\color{accent}#1}\par}
\newcommand\fa@contact@inline[3]{%
  \mbox{{\color{accent}#1}\hspace{0.35em}%
    {\hypersetup{urlcolor=fa@ink}\fa@maybelink{#3}{#2}}}%
  \hspace{1.1em plus 0.4em minus 0.3em}\allowbreak}

\newcommand\fa@namewithcredentials{%
  {\fa@namefont\fa@app{name}}%
  \fa@ifapp{credentials}{{\sffamily\large\color{fa@muted},\,\fa@app{credentials}}}{}%
  \fa@ifapp{pronouns}{\hspace{0.6em}{\fa@metafont(\fa@app{pronouns})}}{}}

\newcommand\fa@currentrole{%
  \fa@ifapp{position}{\fa@app{position}\par}{}%
  \fa@ifapp{department}{\fa@app{department}\par}{}%
  \fa@ifapp{institution}{\fa@app{institution}\par}{}}

\newcommand\fa@letterhead@split{%
  \begingroup
  \setlength\parskip{0pt}%
  \noindent
  \begin{minipage}[b]{0.6\linewidth}
    \raggedright
    \fa@namewithcredentials\par
    \vspace{4pt}%
    {\fa@metafont\fa@currentrole}%
  \end{minipage}%
  \hfill
  \begin{minipage}[b]{0.39\linewidth}
    \raggedleft\fa@contactfont
    \fa@forcontacts\fa@contact@stacked
  \end{minipage}\par
  \vspace{7pt}%
  {\color{accent}\rule{\linewidth}{1.1pt}}\par
  \endgroup}

\newcommand\fa@letterhead@centered{%
  \begingroup
  \setlength\parskip{0pt}%
  \centering
  \fa@namewithcredentials\par
  \vspace{3pt}%
  {\fa@metafont
    \fa@ifapp{position}{\fa@app{position}}{}%
    \fa@ifapp{department}{\fa@sep\fa@app{department}}{}%
    \fa@ifapp{institution}{\fa@sep\fa@app{institution}}{}\par}%
  \vspace{5pt}%
  {\fa@contactfont\fa@forcontacts\fa@contact@inline\unskip\par}%
  \vspace{6pt}%
  {\color{accent}\rule{\linewidth}{1.1pt}}\par
  \endgroup}

\newcommand\fa@letterhead{\csname fa@letterhead@\fa@header\endcsname}

\newcommand\fa@doctitleblock{%
  \begingroup
  \setlength\parskip{0pt}%
  \vspace{12pt}%
  {\fa@doctitlefont\fa@doc@title\par}%
  \ifx\fa@doc@subtitle\@empty\else
    \vspace{3pt}{\sffamily\small\color{fa@muted}\fa@doc@subtitle\par}%
  \fi
  \vspace{2pt}%
  \endgroup}

%% ---------------------------------------------------------------------
%% 10. Application documents: registry, numbering, anchors, limits
%% ---------------------------------------------------------------------
\newcounter{fa@doc}
\newif\iffa@doc@contents
\newif\iffa@doc@numbered
\newif\iffa@doc@showtitle
\newif\iffa@doc@letterhead
\newif\iffa@doc@ragged

\pgfkeys{/facultyapp/document/.cd,
  short/.code      = {\gdef\fa@doc@short{#1}},
  subtitle/.code   = {\gdef\fa@doc@subtitle{#1}},
  page limit/.code = {\gdef\fa@doc@limit{#1}},
  contents/.is if   = fa@doc@contents,
  numbered/.is if   = fa@doc@numbered,
  title/.is if      = fa@doc@showtitle,
  letterhead/.is if = fa@doc@letterhead,
  ragged/.is if     = fa@doc@ragged,
  contents depth/.code = {\gdef\fa@doc@tocdepth{#1}},
  .unknown/.code = {%
    \ClassWarning{facultyapp}{Unknown document option `\pgfkeyscurrentname'}},
}

% registry of documents, filled from the .aux file of the previous run
\def\fa@doclist{}
\newcommand\fa@registerdoc[2]{%
  \ifinlist{#1}{\fa@doclist}{}{\listgadd\fa@doclist{#1}}%
  \global\@namedef{fa@doctitle@#1}{#2}}

\newcommand*\fa@docstart[1]{\zref@extractdefault{fadoc-#1-start}{abspage}{0}}
\newcommand*\fa@docend[1]{\zref@extractdefault{fadoc-#1-end}{abspage}{0}}
\newcommand*\fa@docpages[1]{%
  \ifnum\fa@docend{#1}>0
    \the\numexpr\fa@docend{#1}-\fa@docstart{#1}+1\relax
  \fi}

\newcommand\fa@doc@lookup{%
  \zref@refused{fadoc-\fa@doc@id-start}%
  \zref@refused{fadoc-\fa@doc@id-end}%
  \xdef\fa@doc@pages{\fa@docpages{\fa@doc@id}}%
  \gdef\fa@doc@overlimit{}%
  \ifx\fa@doc@limit\@empty\else\ifx\fa@doc@pages\@empty\else
    \ifnum\fa@doc@pages>\fa@doc@limit\relax
      \gdef\fa@doc@overlimit{1}%
      \ClassWarningNoLine{facultyapp}{%
        `\expandafter\detokenize\expandafter{\fa@doc@short}' is
        \fa@doc@pages\space pages long;\MessageBreak
        its page limit is \fa@doc@limit}%
    \fi
  \fi\fi}

\newcommand\fa@doc@register{%
  \begingroup
  \edef\fa@tmp{\endgroup
    \noexpand\protected@write\noexpand\@auxout{}{%
      \noexpand\string\noexpand\fa@registerdoc{\fa@doc@id}{\noexpand\fa@doc@short}}}%
  \fa@tmp}

\newcommand\fa@doc@anchor{%
  \phantomsection
  \label{fadoc:\fa@doc@id}%
  \addcontentsline{toc}{part}{\fa@doc@short}%
  \edef\fa@tmp{fadoc-\fa@doc@id-start}%
  \expandafter\zlabel\expandafter{\fa@tmp}}

\newenvironment{applicationdocument}[2][]{%
  \clearpage
  \stepcounter{fa@doc}%
  \xdef\fa@doc@id{\the\c@fa@doc}%
  \gdef\fa@doc@title{#2}%
  \gdef\fa@doc@short{#2}%
  \gdef\fa@doc@subtitle{}%
  \gdef\fa@doc@limit{}%
  \gdef\fa@doc@tocdepth{section}%
  \fa@doc@contentsfalse\fa@doc@numberedfalse\fa@doc@raggedfalse
  \fa@doc@showtitletrue\fa@doc@letterheadtrue
  \pgfkeys{/facultyapp/document/.cd,#1}%
  \setcounter{page}{1}%
  \setcounter{section}{0}%
  \setcounter{footnote}{0}%
  \setcounter{figure}{0}%
  \setcounter{table}{0}%
  \gdef\thesection{\arabic{section}}%
  \setcounter{secnumdepth}{\iffa@doc@numbered 2\else 0\fi}%
  \iffa@doc@ragged\RaggedRight\fi
  \fa@doc@lookup
  \fa@doc@register
  \fa@doc@anchor
  \iffa@doc@letterhead\fa@letterhead\fi
  \iffa@doc@showtitle\fa@doctitleblock\fi
  \iffa@doc@contents\documentcontents\fi
}{%
  \par
  \edef\fa@tmp{fadoc-\fa@doc@id-end}%
  \expandafter\zlabel\expandafter{\fa@tmp}%
  \clearpage
  \gdef\fa@doc@short{}%
  \gdef\fa@doc@pages{}%
  \gdef\fa@doc@overlimit{}%
}

%% local table of contents (used by the `contents' option)
\newcommand\fa@tocdots{\nobreak\leaders\hbox to 0.7em{\hss.\hss}\hfill\nobreak}
\newcommand\documentcontents{%
  \begingroup
  \etocsettocstyle{%
    \vspace{6pt}%
    \noindent{\sffamily\bfseries\small\color{accent}\MakeUppercase{Contents}}\par
    \vspace{2pt}\setlength\parskip{0pt}}{\par\vspace{4pt}}%
  \etocsetstyle{section}{}{\leavevmode\leftskip0pt}%
    {\sffamily\small
     \makebox[1.6em][l]{\etocnumber}\etocname\fa@tocdots\etocpage\par}{}%
  \etocsetstyle{subsection}{}{\leavevmode\leftskip1.6em}%
    {\sffamily\small\color{fa@muted}%
     \etocname\fa@tocdots\etocpage\par}{}%
  \edef\fa@savedtocdepth{\the\c@tocdepth}%
  \expandafter\etocsettocdepth\expandafter{\fa@doc@tocdepth}%
  \localtableofcontents
  \setcounter{tocdepth}{\fa@savedtocdepth}%
  \endgroup}

%% ---------------------------------------------------------------------
%% 11. Cover page (full package only)
%% ---------------------------------------------------------------------
\newcommand\fa@coverrows{}
\newcommand\fa@coverrow[1]{%
  \hyperref[fadoc:#1]{\csname fa@doctitle@#1\endcsname}
  & {\color{fa@muted}\fa@docpages{#1}}
  & \hyperref[fadoc:#1]{\fa@docstart{#1}}\\}

\newcommand\makecoverpage{%
  \if@partsw\else\fa@makecoverpage\fi}

\newcommand\fa@makecoverpage{%
  \begingroup
  \thispagestyle{empty}%
  \setlength\parskip{0pt}%
  \pdfbookmark[\csname toclevel@part\endcsname]{Cover page}{fa-coverpage}%
  \vspace*{1.6cm}%
  \noindent
  \tikz[remember picture,overlay]{\fill[accent] (current page.north west)
    rectangle ([xshift=7mm]current page.south west);}%
  {\sffamily\small\color{fa@muted}\MakeUppercase{\facultyappCoverKicker}\par}
  \vspace{8pt}%
  {\sffamily\bfseries\fontsize{26}{31}\selectfont\color{accent}\RaggedRight
    \fa@pos{title}\par}
  \fa@ifpos{field}{\vspace{4pt}%
    {\sffamily\fontsize{17}{21}\selectfont\color{fa@ink}\RaggedRight
      \fa@pos{field}\par}}{}%
  \vspace{14pt}%
  {\large
    \fa@ifpos{department}{\fa@pos{department}\par}{}%
    \fa@ifpos{faculty}{\fa@pos{faculty}\par}{}%
    \fa@ifpos{institution}{\textbf{\fa@pos{institution}}\par}{}}%
  \fa@ifpos{reference}{\vspace{6pt}%
    {\sffamily\small\color{fa@muted}\facultyappReferenceName~\fa@pos{reference}\par}}{}%
  \vspace{1.5cm}%
  {\color{accent}\rule{2.4cm}{1.6pt}}\par
  \vspace{12pt}%
  {\sffamily\small\color{fa@muted}\MakeUppercase{\facultyappSubmittedBy}\par}
  \vspace{6pt}%
  \fa@namewithcredentials\par
  \vspace{5pt}%
  {\fa@metafont\fa@currentrole}%
  \vspace{8pt}%
  {\fa@contactfont\RaggedRight\fa@forcontacts\fa@contact@inline\unskip\par}%
  \vspace{1.5cm}%
  {\sffamily\small\color{fa@muted}\MakeUppercase{\facultyappContentsName}\par}
  \vspace{6pt}%
  \ifx\fa@doclist\@empty
    {\itshape\color{fa@muted}(Compile once more to list the documents.)\par}%
  \else
    \def\fa@coverrows{}%
    \renewcommand*\do[1]{\appto\fa@coverrows{\fa@coverrow{##1}}}%
    \dolistloop\fa@doclist
    {\sffamily
     \renewcommand\arraystretch{1.45}%
     \begin{tabularx}{\linewidth}{@{}X r r@{}}
       \colhead{Document} & \colhead{Pages} & \colhead{\enspace Starts on PDF page}\\
       \midrule
       \fa@coverrows
       \bottomrule
     \end{tabularx}\par}%
  \fi
  \vfill
  {\sffamily\small\color{fa@muted}\today\par}%
  \clearpage
  \endgroup}

%% ---------------------------------------------------------------------
%% 12. Cover letter
%% ---------------------------------------------------------------------
\def\fa@letter@date{\today}
\def\fa@letter@closing{Sincerely,}
\def\fa@letter@subject{auto}
\def\fa@letter@enclosures{auto}
\def\fa@letter@limit{}
\pgfkeys{/facultyapp/letter/.cd,
  date/.code        = {\def\fa@letter@date{#1}},
  closing/.code     = {\def\fa@letter@closing{#1}},
  subject/.code     = {\def\fa@letter@subject{#1}},
  enclosures/.code  = {\def\fa@letter@enclosures{#1}},
  page limit/.code  = {\def\fa@letter@limit{#1}},
  .unknown/.code = {%
    \ClassWarning{facultyapp}{Unknown coverletter option `\pgfkeyscurrentname'}},
}

\newcommand\fa@letter@autosubject{%
  \facultyappSubjectPrefix\ Application for the position of \fa@pos{title}%
  \fa@ifpos{field}{ in \fa@pos{field}}{}%
  \fa@ifpos{reference}{ (\facultyappReferenceName~\fa@pos{reference})}{}}

\newcommand\fa@letter@recipientblock{%
  \begingroup
  \setlength\parskip{0pt}\RaggedRight
  \fa@ifpos{recipient}{\fa@pos{recipient}\par}{}%
  \fa@ifpos{recipient title}{\fa@pos{recipient title}\par}{}%
  \fa@ifpos{department}{\fa@pos{department}\par}{}%
  \fa@ifpos{faculty}{\fa@pos{faculty}\par}{}%
  \fa@ifpos{institution}{\fa@pos{institution}\par}{}%
  \fa@ifpos{address}{\fa@pos{address}\par}{}%
  \endgroup}

\newcommand\fa@letter@opening{%
  \vspace{4pt}%
  {\RaggedRight\fa@letter@date\par}%
  \vspace{\parskip}%
  \fa@letter@recipientblock
  \def\fa@tmp{none}%
  \ifx\fa@letter@subject\fa@tmp\else
    {\RaggedRight\bfseries
     \def\fa@tmp{auto}%
     \ifx\fa@letter@subject\fa@tmp\fa@letter@autosubject\else\fa@letter@subject\fi
     \par}%
  \fi
  \fa@ifpos{salutation}{\fa@pos{salutation}}%
    {Dear \fa@ifpos{recipient}{\fa@pos{recipient}}{Members of the Search Committee},}%
  \par}

\newcommand\fa@letter@enclosurelist{%
  \def\fa@tmp{}%
  \renewcommand*\do[1]{%
    \ifnum##1=\fa@doc@id\relax\else
      \ifx\fa@tmp\@empty\else\appto\fa@tmp{; }\fi
      \eappto\fa@tmp{\expandonce{\csname fa@doctitle@##1\endcsname}}%
    \fi}%
  \dolistloop\fa@doclist
  \fa@tmp}

\newcommand\fa@letter@signoff{%
  \par
  \noindent\begin{minipage}{\linewidth}
    \setlength\parskip{0pt}\RaggedRight
    \fa@letter@closing\par
    \fa@ifapp{signature}{%
      \IfFileExists{\fa@app{signature}}%
        {\vspace{2pt}\includegraphics[height=1.3cm]{\fa@app{signature}}\par\vspace{1pt}}%
        {\vspace{1.5\baselineskip}}}%
      {\vspace{1.5\baselineskip}}%
    \textbf{\fa@app{name}}\fa@ifapp{credentials}{, \fa@app{credentials}}{}\par
    {\fa@metafont
     \fa@ifapp{position}{\fa@app{position}\par}{}%
     \fa@ifapp{institution}{\fa@app{institution}\par}{}}%
  \end{minipage}\par
  \def\fa@tmp{none}%
  \ifx\fa@letter@enclosures\fa@tmp\else
    \def\fa@tmp{auto}%
    \ifx\fa@letter@enclosures\fa@tmp
      \ifx\fa@doclist\@empty\else
        {\small\leavevmode\color{fa@muted}\textit{\facultyappEnclosuresName:} \fa@letter@enclosurelist\par}%
      \fi
    \else
      {\small\leavevmode\color{fa@muted}\textit{\facultyappEnclosuresName:} \fa@letter@enclosures\par}%
    \fi
  \fi}

\newenvironment{coverletter}[1][]{%
  \pgfkeys{/facultyapp/letter/.cd,#1}%
  \edef\fa@tmp{\noexpand\applicationdocument
    [title=false,page limit=\fa@letter@limit]}%
  \fa@tmp{\facultyappCoverLetterName}%
  \fa@letter@opening
}{%
  \fa@letter@signoff
  \endapplicationdocument}

%% ---------------------------------------------------------------------
%% 13. CV building blocks
%% ---------------------------------------------------------------------
\newlength\fa@cvlabelwidth
\setlength\fa@cvlabelwidth{\fa@cvlabelwidthval}

% right-aligns #1 at the end of the current line, or on a new line
% when there is no room (Knuth, The TeXbook, p. 106)
\newcommand\fa@rightinfo[1]{%
  {\unskip\nobreak\hfil\penalty50\hskip1.5em\hbox{}\nobreak\hfil#1%
   \parfillskip=0pt \finalhyphendemerits=0 \par}}

% \cventry{<dates>}{<title>}{<organisation>}{<location / amount>}{<details>}
\newcommand\cventry[5]{%
  \par
  \if@nobreak\else\addvspace{5pt plus 1pt}\fi
  \begingroup
  \setlength\parskip{0pt}%
  \noindent{\fa@entrytitlefont #2}\fa@rightinfo{\fa@labelfont #1}%
  \ifboolexpr{test {\ifblank{#3}} and test {\ifblank{#4}}}{}{%
    \nobreak
    \noindent{\fa@orgfont #3}\fa@rightinfo{\fa@labelfont #4}}%
  \ifblank{#5}{}{%
    \nobreak\vspace{1pt}%
    {\fa@detailfont #5\par}}%
  \endgroup
  \par}

% \cvitem{<label, e.g. year>}{<text>}
\newcommand\cvitem[2]{%
  \par
  \begin{list}{}{%
    \setlength\leftmargin{\fa@cvlabelwidth}%
    \setlength\labelwidth{\fa@cvlabelwidth}%
    \setlength\labelsep{0pt}\setlength\itemindent{0pt}%
    \setlength\topsep{1.5pt}\setlength\partopsep{0pt}%
    \setlength\parsep{0pt}\setlength\itemsep{0pt}%
    \renewcommand\makelabel[1]{{\fa@labelfont##1}\hfil}}%
  \item[#1]#2%
  \end{list}}

% small muted note, e.g. under a section heading
\newcommand\cvnote[1]{\par{\small\leavevmode\color{fa@muted}#1\par}}

%% ---------------------------------------------------------------------
%% 14. Publications from BibLaTeX
%% ---------------------------------------------------------------------
\RequirePackage[
  backend=biber,
  style=numeric,
  sorting=ydnt,
  maxbibnames=99,
  giveninits=true,
  uniquename=false,
  uniquelist=false,
  date=year,
  doi=false,
  url=false,
  isbn=false,
  eprint=true,
  related=false,
]{biblatex}
% we number publication lists ourselves (see \publist)
\ifdefined\BiblatexSplitbibDefernumbersWarningOff
  \BiblatexSplitbibDefernumbersWarningOff
\fi

% `award = {...}' in a .bib entry is shown with a trophy
\DeclareSourcemap{\maps[datatype=bibtex]{%
  \map{\step[fieldsource=award,fieldtarget=usera]}}}
\DeclareFieldFormat{usera}{\textcolor{accent}{\faTrophy\addnbspace#1}}
\renewbibmacro*{finentry}{%
  \iffieldundef{usera}{}{\setunit{\addperiod\space}\printfield{usera}}%
  \finentry}

% titles link to the DOI (or URL)
\newcommand\fa@linkentry[1]{%
  \iffieldundef{doi}
    {\iffieldundef{url}{#1}{\href{\thefield{url}}{#1}}}%
    {\href{https://doi.org/\thefield{doi}}{#1}}}
\DeclareFieldFormat{title}{\fa@linkentry{\mkbibemph{#1}}}
\DeclareFieldFormat
  [article,inbook,incollection,inproceedings,patent,thesis,unpublished,misc,online,report]
  {title}{\fa@linkentry{\mkbibquote{#1\isdot}}}
\renewbibmacro*{in:}{%
  \ifentrytype{article}{}{\printtext{\bibstring{in}\intitlepunct}}}
\AtEveryBibitem{%
  \clearfield{month}\clearfield{day}\clearfield{issn}%
  \clearlist{language}\clearfield{urlyear}\clearfield{urlmonth}}

% --- highlight your own name ------------------------------------------
%  \highlightauthor{<family>}{<given, as in your .bib, or empty>}
%  (alternatively annotate:  author+an = {2=highlight} )
\newif\iffa@hl
\def\fa@hlnames{}
\newcommand\highlightauthor[2]{\appto\fa@hlnames{\fa@hlcheck{#1}{#2}}}
\newcommand\fa@normalise[2]{%
  \begingroup
    \def\bibnamedelima{ }\def\bibnamedelimb{ }%
    \def\bibnamedelimc{ }\def\bibnamedelimd{ }%
    \def\bibnamedelimi{ }\def\bibinitdelim{ }%
    \def\bibinitperiod{.}\def\bibinithyphendelim{.-}%
    \protected@edef\fa@tmp{#2}%
    \expandafter\endgroup\expandafter\def\expandafter#1\expandafter{\fa@tmp}}
\newcommand\fa@hlcheck[2]{%
  \ifdefstring{\fa@nfamily}{#1}
    {\ifblank{#2}{\fa@hltrue}{\ifdefstring{\fa@ngiven}{#2}{\fa@hltrue}{}}}%
    {}}
\newcommand\fa@highlightformat[1]{\textbf{#1}}
\newcommand\fa@mark@equal{\textsuperscript{*}}
\newcommand\fa@mark@trainee{\textsuperscript{\textdagger}}
\newcommand\fa@mark@corresponding{\textsuperscript{\textdaggerdbl}}
\renewcommand*{\mkbibcompletename}[1]{%
  \fa@hlfalse
  \ifitemannotation{highlight}{\fa@hltrue}{}%
  \iffa@hl\else
    \fa@normalise\fa@nfamily{\namepartfamily}%
    \fa@normalise\fa@ngiven{\namepartgiven}%
    \fa@hlnames
  \fi
  \iffa@hl\fa@highlightformat{#1}\else#1\fi
  \ifitemannotation{equal}{\fa@mark@equal}{}%
  \ifitemannotation{trainee}{\fa@mark@trainee}{}%
  \ifitemannotation{corresponding}{\fa@mark@corresponding}{}}

% legend for the marks, e.g. under the Publications heading
\newcommand\publicationlegend{%
  \cvnote{%
    \textbf{Bold}: \fa@app{name}\fa@sep
    \fa@mark@trainee\,trainee under my supervision\fa@sep
    \fa@mark@equal\,equal contribution\fa@sep
    \fa@mark@corresponding\,corresponding author}}

% --- categorised, reverse-numbered publication lists ---------------------
%  \publist[<prefix>]{<heading>}{<\printbibliography filters>}
\newcounter{fa@publist}
\newcounter{fa@pubitem}
\def\fa@pubprefix{}
\def\fa@pubtotal{}
\newcommand\fa@setpubtotal[2]{\global\@namedef{fa@pubtotal@#1}{#2}}
\def\fa@str@descending{descending}
\newcommand*\fa@pubnumber{% expandable
  \ifx\fa@pubnumbering\fa@str@descending
    \ifx\fa@pubtotal\@empty\the\c@fa@pubitem
    \else\the\numexpr\fa@pubtotal-\c@fa@pubitem+1\relax\fi
  \else\the\c@fa@pubitem\fi}
\newcommand\fa@publabel{%
  {\fa@labelfont
   \ifdefstring{\fa@pubnumbering}{none}{}{[\fa@pubprefix\fa@pubnumber]}}}
\newcommand\fa@pubfinish{%
  \immediate\write\@auxout{%
    \string\fa@setpubtotal{\the\c@fa@publist}{\the\c@fa@pubitem}}%
  \ifx\fa@pubtotal\@empty
    \fa@pubrerun
  \else\ifnum\fa@pubtotal=\c@fa@pubitem\else\fa@pubrerun\fi\fi}
\newcommand\fa@pubrerun{%
  \@latex@warning@no@line{Publication numbering has changed.
    Rerun to get cross-references right}}

\defbibheading{fa@publist}[]{\subsection{#1}}
\defbibenvironment{fa@publist}
  {\setcounter{fa@pubitem}{0}%
   \list{\fa@publabel}{%
     \setlength{\leftmargin}{\fa@cvlabelwidth}%
     \setlength{\labelwidth}{\fa@cvlabelwidth}%
     \setlength{\labelsep}{0pt}%
     \setlength{\itemindent}{0pt}%
     \setlength{\itemsep}{3pt}%
     \setlength{\parsep}{0pt}%
     \setlength{\topsep}{2pt}%
     \renewcommand*{\makelabel}[1]{##1\hfil}}%
   \RaggedRight\hyphenpenalty=3000\exhyphenpenalty=5000\emergencystretch=2.5em\relax}
  {\fa@pubfinish\endlist}
  {\stepcounter{fa@pubitem}\item\fa@pubrecord}

% remember each entry's CV label (for \cite) and give it a link target
\newcommand\fa@setpublabel[2]{\global\@namedef{fa@publabel@#1}{#2}}
\newcommand\fa@pubrecord{%
  \edef\fa@tmp{\thefield{entrykey}}%
  \ifcsname fa@pubanchor@\fa@tmp\endcsname\else
    \global\@namedef{fa@pubanchor@\fa@tmp}{}%
    \hypertarget{fapub:\fa@tmp}{}%
    \immediate\write\@auxout{%
      \string\fa@setpublabel{\fa@tmp}{\fa@pubprefix\fa@pubnumber}}%
  \fi}

% \cite{key1,key2} -> [J5, C3], linked to the CV entries
\newcommand\fa@citelabel{%
  \edef\fa@tmp{\thefield{entrykey}}%
  \ifcsname fa@publabel@\fa@tmp\endcsname
    {\hypersetup{linkcolor=accent}%
     \hyperlink{fapub:\fa@tmp}{\csname fa@publabel@\fa@tmp\endcsname}}%
  \else
    \textbf{??}%
    \G@refundefinedtrue
    \@latex@warning{Publication `\fa@tmp' has no CV label yet.\MessageBreak
      Rerun, or make sure a \string\publist\space shows it}%
  \fi}
\DeclareCiteCommand{\cite}[\mkbibbrackets]
  {\usebibmacro{prenote}}{\fa@citelabel}{\addcomma\space}{\usebibmacro{postnote}}
\DeclareCiteCommand{\parencite}[\mkbibbrackets]
  {\usebibmacro{prenote}}{\fa@citelabel}{\addcomma\space}{\usebibmacro{postnote}}

\newcommand\publist[3][]{%
  \stepcounter{fa@publist}%
  \gdef\fa@pubprefix{#1}%
  \xdef\fa@pubtotal{%
    \ifcsname fa@pubtotal@\the\c@fa@publist\endcsname
      \csname fa@pubtotal@\the\c@fa@publist\endcsname
    \fi}%
  \printbibliography[heading=fa@publist,title={#2},env=fa@publist,#3]}

%% ---------------------------------------------------------------------
%% 15. Teaching dossier building blocks
%% ---------------------------------------------------------------------
% key numbers:  \begin{keystats}[<columns>] \keystat{6}{courses} ... \end{keystats}
\newenvironment{keystats}[1][4]{%
  \par
  \begin{tcbraster}[raster columns=#1,raster equal height,
    raster column skip=6pt,raster row skip=6pt,
    raster before skip=4pt,raster after skip=6pt]}
  {\end{tcbraster}}
\newcommand\keystat[2]{%
  \begin{tcolorbox}[enhanced,colback=accent!7,colframe=accent!7,boxrule=0pt,
    arc=3pt,halign=center,valign=center,top=6pt,bottom=6pt,left=3pt,right=3pt]
    {\sffamily\bfseries\fontsize{19}{22}\selectfont\color{accent}#1}\par
    \vspace{3pt}%
    {\sffamily\footnotesize\color{fa@muted}\hyphenpenalty=10000 #2\par}
  \end{tcolorbox}}

% \ratingbar[<benchmark>]{<score>}{<maximum>}
\newlength\fa@barwidth
\setlength\fa@barwidth{2.2cm}
\newcommand\ratingbar[3][]{%
  \begin{tikzpicture}[baseline=0pt]
    \pgfmathsetlengthmacro\fa@w{min(max(#2,0),#3)/#3*\fa@barwidth}%
    \fill[accent!14,rounded corners=1pt] (0,0) rectangle (\fa@barwidth,1.15ex);
    \fill[accent,rounded corners=1pt] (0,0) rectangle (\fa@w,1.15ex);
    \ifblank{#1}{}{%
      \pgfmathsetlengthmacro\fa@b{min(max(#1,0),#3)/#3*\fa@barwidth}%
      \draw[fa@ink,line width=1pt] (\fa@b,-0.35ex) -- (\fa@b,1.5ex);}%
  \end{tikzpicture}%
  \hspace{0.5em}{\sffamily #2}}
\newcommand\ratinglegend{%
  {\sffamily\footnotesize\color{fa@muted}%
   \tikz[baseline=0pt]{\fill[accent,rounded corners=1pt] (0,0) rectangle (0.5cm,1.15ex);}~my score\quad
   \tikz[baseline=0pt]{\draw[fa@ink,line width=1pt] (0,-0.35ex) -- (0,1.5ex);}~comparison mean}}

% \studentquote[<source>]{<quotation>}
\newcommand\studentquote[2][]{%
  \begin{tcolorbox}[blanker,breakable,borderline west={2pt}{0pt}{accent!55},
    left=10pt,right=6pt,top=1pt,bottom=1pt,before skip=5pt,after skip=7pt]
    \itshape\enquote{#2}%
    \ifblank{#1}{}{\par\vspace{2pt}%
      {\upshape\sffamily\footnotesize\color{fa@muted}--- #1}}%
  \end{tcolorbox}}

% data tables that may break across pages:
%   \begin{datatable}{l X r}  ... \end{datatable}
\newcommand\colhead[1]{\leavevmode{\sffamily\bfseries\footnotesize\color{fa@muted}#1}}
\newenvironment{datatable}[1]{%
  \par\small
  \renewcommand\tabularxcolumn[1]{>{\RaggedRight\arraybackslash}p{##1}}%
  \setlength\tabcolsep{5pt}%
  \renewcommand\arraystretch{1.3}%
  \setlength\LTpre{3pt}\setlength\LTpost{3pt}%
  \xltabular{\linewidth}{#1}}
  {\endxltabular}

%% ---------------------------------------------------------------------
%% 16. Referees
%% ---------------------------------------------------------------------
\fa@definestorekeys{/facultyapp/referee}{fa@ref}{%
name,title,department,institution,address,email,phone,relationship,note}
\pgfkeys{/facultyapp/referee/.unknown/.code={%
  \ClassWarning{facultyapp}{Unknown \string\referee\space key `\pgfkeyscurrentname'}}}
\newcommand*\fa@ref[1]{\csname fa@ref@#1\endcsname}
\newcommand*\fa@ifref[1]{\fa@ifset{fa@ref@#1}}

\newenvironment{referees}[1][2]{%
  \par
  \begin{tcbraster}[raster columns=#1,raster equal height=rows,
    raster column skip=12pt,raster row skip=10pt,
    raster before skip=6pt,raster after skip=6pt]}
  {\end{tcbraster}}

\newcommand\referee[1]{%
  \@for\fa@tmpkey:={name,title,department,institution,address,email,%
    phone,relationship,note}\do{\expandafter\gdef\csname fa@ref@\fa@tmpkey\endcsname{}}%
  \pgfkeys{/facultyapp/referee/.cd,#1}%
  \begin{tcolorbox}[enhanced,colback=accent!4,colframe=accent!4,boxrule=0pt,
    borderline west={2.2pt}{0pt}{accent},arc=2pt,
    left=10pt,right=8pt,top=7pt,bottom=7pt,fontupper=\small]
    \setlength\parskip{0pt}\raggedright
    {\sffamily\bfseries\normalsize\color{fa@ink}\fa@ref{name}\par}%
    \fa@ifref{title}{{\itshape\fa@ref{title}}\par}{}%
    \fa@ifref{department}{\fa@ref{department}\par}{}%
    \fa@ifref{institution}{\fa@ref{institution}\par}{}%
    \fa@ifref{address}{\fa@ref{address}\par}{}%
    \vspace{4pt}%
    \fa@ifref{email}{\makebox[1.3em][l]{\color{accent}\faEnvelope}%
      {\hypersetup{urlcolor=fa@ink}\href{mailto:\fa@ref{email}}{\fa@ref{email}}}\par}{}%
    \fa@ifref{phone}{\makebox[1.3em][l]{\color{accent}\faPhone}\fa@ref{phone}\par}{}%
    \fa@ifref{relationship}{\vspace{4pt}%
      {\sffamily\footnotesize\color{fa@muted}\fa@ref{relationship}}\par}{}%
    \fa@ifref{note}{\vspace{2pt}%
      {\sffamily\footnotesize\color{accent}\fa@ref{note}}\par}{}%
  \end{tcolorbox}}

%% ---------------------------------------------------------------------
%% 17. Writing tips (visible only with the `tips' option)
%% ---------------------------------------------------------------------
\newtcolorbox{fa@tipbox}{enhanced,breakable,
  colback=accent!6,colframe=accent!6,boxrule=0pt,
  borderline west={2.5pt}{0pt}{fa@alert!80},arc=2pt,
  left=9pt,right=8pt,top=5pt,bottom=5pt,
  before skip=6pt,after skip=8pt,
  fontupper=\sffamily\small\color{fa@ink}}
\newcommand\tip[2][Tip]{%
  \iffa@tips
    \begin{fa@tipbox}
      \setlength\parskip{4pt}%
      {\color{fa@alert}\faLightbulb[regular]\enspace\textbf{#1.}}\enspace #2
    \end{fa@tipbox}%
  \fi}

%% ---------------------------------------------------------------------
%% 18. Hyperlinks and PDF metadata
%% ---------------------------------------------------------------------
\RequirePackage[
  colorlinks=true,
  linkcolor=fa@ink,
  urlcolor=accent,
  citecolor=accent,
  hypertexnames=false,
  pdfpagelabels=false,
  bookmarksopen=true,
  bookmarksopenlevel=-1,
  bookmarksdepth=3,
  pdfdisplaydoctitle=true,
  unicode=true,
]{hyperref}
\urlstyle{same}

\AtBeginDocument{%
  \protected@edef\fa@tmp{\fa@app{website}}%
  \expandafter\in@\expandafter:\expandafter{\fa@tmp}%
  \ifin@\let\fa@weburl\fa@tmp\else\edef\fa@weburl{https://\fa@tmp}\fi
  \hypersetup{
    pdfauthor   = {\fa@app{name}},
    pdftitle    = {\fa@app{name} -- Application: \fa@pos{title}%
                   \fa@ifpos{institution}{, \fa@pos{institution}}{}},
    pdfsubject  = {Faculty application},
    pdfkeywords = {faculty application, cover letter, curriculum vitae,
                   research statement, teaching dossier, EDIA statement,
                   references},
    pdfcreator  = {LaTeX with facultyapp.cls},
  }}
% language tag for screen readers and other assistive technology
\def\fa@tmp#1#2{\@namedef{fa@lang@#1}{#2}}
\fa@tmp{english}{en}\fa@tmp{american}{en-US}\fa@tmp{USenglish}{en-US}
\fa@tmp{canadian}{en-CA}\fa@tmp{british}{en-GB}\fa@tmp{UKenglish}{en-GB}
\fa@tmp{australian}{en-AU}\fa@tmp{newzealand}{en-NZ}
\fa@tmp{french}{fr}\fa@tmp{canadien}{fr-CA}\fa@tmp{acadian}{fr-CA}
\fa@tmp{german}{de}\fa@tmp{ngerman}{de}\fa@tmp{spanish}{es}
\fa@tmp{italian}{it}\fa@tmp{portuguese}{pt}\fa@tmp{brazilian}{pt-BR}
\fa@tmp{dutch}{nl}
\ifcsname fa@lang@\fa@language\endcsname
  \edef\fa@tmp{\noexpand\hypersetup{pdflang=\csname fa@lang@\fa@language\endcsname}}%
  \fa@tmp
\fi

\endinput
