(in-package #:gs-session-action-ledger)

(defun main-entry ()
  (handler-case
      (main)
    (error (err)
      (format *error-output* "Error: ~a~%" err)
      (uiop:quit 1))))
