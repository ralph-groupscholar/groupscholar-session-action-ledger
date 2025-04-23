(defpackage #:gs-session-action-ledger/tests
  (:use #:cl #:fiveam))

(in-package #:gs-session-action-ledger/tests)

(def-suite :gs-session-action-ledger)
(in-suite :gs-session-action-ledger)

(defun with-env (name value thunk)
  (let ((old (uiop:getenv name)))
    (unwind-protect
        (progn
          (if value
              (sb-posix:setenv name value 1)
              (sb-posix:unsetenv name))
          (funcall thunk))
      (if old
          (sb-posix:setenv name old 1)
          (sb-posix:unsetenv name)))))

(test env-or-default-fallback
  (with-env "GS_SAL_TEST" nil
            (lambda ()
              (is (string= "fallback" (gs-session-action-ledger:env-or-default "GS_SAL_TEST" "fallback"))))))

(test env-or-default-present
  (with-env "GS_SAL_TEST" "present"
            (lambda ()
              (is (string= "present" (gs-session-action-ledger:env-or-default "GS_SAL_TEST" "fallback"))))))

(test required-env-missing
  (with-env "GS_SAL_REQUIRED" nil
            (lambda ()
              (signals error (gs-session-action-ledger:required-env "GS_SAL_REQUIRED")))))

(test parse-int-default
  (is (null (gs-session-action-ledger:parse-int "not-a-number" :default nil))))

(test parse-int-value
  (is (= 42 (gs-session-action-ledger:parse-int "42" :default 0))))

(defun run-tests ()
  (run! :gs-session-action-ledger))
