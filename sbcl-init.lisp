(require 'sb-posix)
(require 'asdf)

(defun portacle-root ()
  (pathname (or (sb-posix:getenv "ROOT") (user-homedir-pathname))))

;; Ensure nice debuggability
(sb-ext:restrict-compiler-policy 'debug 3)

;; Fix up the source locations
(sb-ext:set-sbcl-source-location (merge-pathnames "sbcl/sources/" (portacle-root)))

;; Fix up the ASDF cache location
(setf asdf:*user-cache*
      (merge-pathnames (format NIL "~a-~a-~a-~a/"
                               (lisp-implementation-type)
                               (lisp-implementation-version)
                               (software-type)
                               (machine-type))
       (merge-pathnames "sbcl/asdf-cache/" (portacle-root))))

;; Load quicklisp
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (portacle-root))))
  (load quicklisp-init))

;; Add the project folder to Quicklisp's local-projects directories.
(pushnew (merge-pathnames "projects/" (portacle-root)) ql:*local-project-directories*)
