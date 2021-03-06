\version "2.17.7"

% David's example from issue 2607, with some modifications
% https://code.google.com/p/lilypond/issues/detail?id=2607#c9

\score
{
  {  $@(map!
       (lambda (p d) #{ < $@p >$@d #})
; this $@ produces elements for a sequential music list via map!.  Each
; element is constructed from p, a list of pitches making up a chord,
; and from d, which is a list first containing a duration followed by
; _optional_ articulations, so $@d actually can return several tokens of
; _different_ type.
;
; The following form constructs the list of pitch lists for use in p
       (map!
	(lambda (i)
	  (map!
	   (lambda (i)
	     (ly:make-pitch 2 (+ 1 (* 9 (quotient i 5)) (* i -2)) 0))
	   (iota 5 i)))
	(append! (iota 34) (list 32)))
; The following form constructs an (end-less) list of lists containing
; a duration and maybe articulations.
       (apply
	circular-list
        (map!
          (lambda (m) (cons (ly:music-property m 'duration)
                            (ly:music-property m 'articulations)))
          (extract-typed-music
	     #{ s4.~ s~ s4~ s2~ s2 #}
             'skip-event))))
      <c' e' g' a' c''>1 \bar "|."
  }
  \layout { }
}
