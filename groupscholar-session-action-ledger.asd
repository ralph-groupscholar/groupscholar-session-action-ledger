(asdf:defsystem "groupscholar-session-action-ledger"
  :description "Session action item ledger for Group Scholar"
  :author "Ralph"
  :license "MIT"
  :depends-on ("postmodern" "uiop")
  :serial t
  :components ((:file "src/package")
               (:file "src/util")
               (:file "src/db")
               (:file "src/cli")
               (:file "src/main")))

(asdf:defsystem "groupscholar-session-action-ledger/tests"
  :description "Tests for groupscholar-session-action-ledger"
  :author "Ralph"
  :license "MIT"
  :depends-on ("groupscholar-session-action-ledger" "fiveam" "uiop")
  :serial t
  :components ((:file "tests/main")))
