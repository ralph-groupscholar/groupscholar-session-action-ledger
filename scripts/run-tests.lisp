(require :asdf)
(load (merge-pathnames "scripts/bootstrap.lisp" (uiop:getcwd)))
(ensure-quicklisp)
(load (merge-pathnames "~/quicklisp/setup.lisp" (user-homedir-pathname)))

(defparameter *project-root* (uiop:getcwd))
(asdf:load-asd (merge-pathnames "groupscholar-session-action-ledger.asd" *project-root*))
(ql:quickload :groupscholar-session-action-ledger/tests)

(gs-session-action-ledger/tests::run-tests)
