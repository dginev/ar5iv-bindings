%
% revtex.cls, version 2, 24-JUL-1995
%
% Temporary fix to RevTeX 3.0 package with LaTeX2e 1994/12/01,
% by David Carlisle, 22 Dec 1994
% Added fix for `control sequences (.e.g. \dag) as biblabel' bug
% (David Carlisle, Christian Spieler, 24 Jul 1995)
%
%
\ifx\every@math@size\undefined\else
  \let\old@expast\@expast
  \def\@expast#1{\old@expast{#1}\let\@tempa\reserved@a}
\fi

\input{revtex.sty}

\@ifundefined{@ExpandsToRefNumber}{\relax}%
{%
\def\@ExpandsToRefNumber #1{%
TT\fi %
\@ifundefined{b@#1}%
{\@tempcntb=1
}%
{\protected@edef\@tempb{\csname b@#1\endcsname}%
\def\@tempa{\@temptokena=\bgroup}%
\if0A { \else  \fi %
\afterassignment\@tempa
\@tempcntb=0\@tempb}%
}%
\ifnum\@tempcntb>0 %
}%
}

\endinput
% end of revtex.cls
