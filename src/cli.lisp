(in-package #:gs-session-action-ledger)

(defun print-actions (rows)
  (dolist (row rows)
    (destructuring-bind (id status due-date owner description session-date session-type mentor scholar) row
      (format t "#~a [~a] due: ~a owner: ~a~%  ~a~%  session: ~a (~a) mentor: ~a scholar: ~a~%~%"
              id status due-date owner description session-date session-type mentor scholar))))

(defun print-summary (summary-data)
  (destructuring-bind (by-status due-soon) summary-data
    (format t "Action items by status:~%")
    (dolist (row by-status)
      (destructuring-bind (status count) row
        (format t "  ~a: ~a~%" status count)))
    (format t "Open actions due in next 14 days: ~a~%" (caar due-soon))))

(defun usage ()
  (format t "Usage:\n")
  (format t "  session-action-ledger add-session <YYYY-MM-DD> <type> <mentor> <scholar> <notes>\n")
  (format t "  session-action-ledger add-action <session-id> <owner> <YYYY-MM-DD> <status> <description>\n")
  (format t "  session-action-ledger close-action <action-id>\n")
  (format t "  session-action-ledger list-actions [status]\n")
  (format t "  session-action-ledger summary\n"))

(defun main ()
  (let* ((args (uiop:command-line-arguments))
         (command (first args))
         (rest (rest args)))
    (cond
      ((null command)
       (usage)
       (uiop:quit 1))
      ((string= command "add-session")
       (ensure-args rest 5 (usage))
       (let ((id (add-session (nth 0 rest) (nth 1 rest) (nth 2 rest) (nth 3 rest) (nth 4 rest))))
         (format t "Created session ~a~%" id)))
      ((string= command "add-action")
       (ensure-args rest 5 (usage))
       (let ((id (add-action (nth 0 rest) (nth 1 rest) (nth 2 rest) (nth 3 rest) (nth 4 rest))))
         (format t "Created action item ~a~%" id)))
      ((string= command "close-action")
       (ensure-args rest 1 (usage))
       (close-action (nth 0 rest))
       (format t "Closed action item ~a~%" (nth 0 rest)))
      ((string= command "list-actions")
       (print-actions (list-actions (first rest))))
      ((string= command "summary")
       (print-summary (summary)))
      (t
       (usage)
       (uiop:quit 1)))))
