(in-package #:gs-session-action-ledger)

(defun env-or-default (name default)
  (let ((value (uiop:getenv name)))
    (if (and value (string/= value ""))
        value
        default)))

(defun required-env (name)
  (let ((value (uiop:getenv name)))
    (when (or (null value) (string= value ""))
      (error "Missing required environment variable: ~a" name))
    value))

(defun parse-int (value &key (default nil))
  (handler-case
      (parse-integer value)
    (error () default)))

(defun ensure-args (args count usage)
  (when (< (length args) count)
    (format t "~a~%" usage)
    (uiop:quit 1)))
