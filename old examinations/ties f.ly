﻿\paper { indent = 0  ragged-right = ##t paper-width = 10 \cm line-width = 9 \cm }

shapeTie =
  #(define-music-function (parser location offsets) (list?)
    #{
       \once \override Tie #'control-points = #(alter-curve $offsets)
    #})

#(define ((alter-curve offsets) grob)
   ;; get default control-points
   (let ((coords (ly:tie::calc-control-points grob))
         (n 0))
     ;; add offsets to default coordinates
     (define loop (lambda (n)
                    (set-car! (list-ref coords n)
                              (+ (list-ref offsets (* 2 n))
                                 (car (list-ref coords n))))
                    (set-cdr! (list-ref coords n)
                              (+ (list-ref offsets (1+ (* 2 n)))
                                 (cdr (list-ref coords n))))
                    (if (< n 3)
                        (loop (1+ n)))))
     ;; return altered coordinates
     (loop n)
     coords))

br = { \bar "" \break }

% #(set-global-staff-size 10)

\markup "f-ties should behave very similar to a-ties"
\markup "(except for long ones, which - unlike a-ties - "
\markup "are not restricted downwards by staffline)."
\markup "Now they are handled completely different:"
\markup "very short ties are farther away from notes,"
\markup "and longer ties are driven into staffline."
\markup "It looks like they behave exactly like d-ties -"
\markup "like if the outer stafflines didn't exist."

\transpose d f

\new Staff \with { \override StaffSymbol #'line-count = #5 \remove Time_signature_engraver } { \time 9999/1 \set tieWaitForNote = ##t
    \mark "3/4"
    d'4*3/4 ~ d'4
    \br
    
    \mark "1"
    d'4 ~ d'4
    \br
    
  }