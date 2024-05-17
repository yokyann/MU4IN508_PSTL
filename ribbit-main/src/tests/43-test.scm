(define (f a b) 
    (let ((x (+ a b)))
    (lambda (z) (* x z))))
(define h 
    (f 3 4))

(putchar (h 8))

;;;expected:
;;;"8" (Asciiz 56)