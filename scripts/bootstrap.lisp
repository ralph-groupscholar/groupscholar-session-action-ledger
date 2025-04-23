(require :asdf)

(defparameter *quicklisp-home*
  (merge-pathnames "quicklisp/" (user-homedir-pathname)))

(defun quicklisp-installed-p ()
  (probe-file (merge-pathnames "setup.lisp" *quicklisp-home*)))

(defun install-quicklisp ()
  (let* ((ql-url "https://beta.quicklisp.org/quicklisp.lisp")
         (ql-file (merge-pathnames "quicklisp.lisp" (uiop:temporary-directory))))
    (uiop:run-program (list "curl" "-L" "-o" (namestring ql-file) ql-url) :output t :error-output t)
    (load ql-file)
    (funcall (read-from-string "quicklisp-quickstart:install") :path *quicklisp-home*)
    (funcall (read-from-string "ql-util:without-prompting")
             (lambda ()
               (funcall (read-from-string "ql:add-to-init-file"))))))

(defun ensure-quicklisp ()
  (unless (quicklisp-installed-p)
    (format t "Installing Quicklisp...~%")
    (install-quicklisp)))
