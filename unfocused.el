;;; unfocused.el --- Run code when Emacs is unfocused -*- lexical-binding: t -*-

;; Copyright (C) 2021 Case Duckworth
;; This file is NOT part of GNU Emacs.

;; Author: Case Duckworth <acdw@acdw.net>
;; License: ISC
;; Version: 0.1
;; Package-Requires: ((emacs "24.1"))
;; Keywords: 
;; URL: https://github.com/duckwork/unfocused

;;; Commentary:

;;; Code:

(defvar unfocused-hooks nil
  "The hooks to run when all Emacs frames are out of focus.")

(defun unfocused-run-hooks ()
  ""
  (when (seq-every-p #'null (mapcar #'frame-focus-state (frame-list)))
    (run-hooks 'unfocused-hooks)))

(define-minor-mode unfocused-mode
  "Toggle `unfocused-mode'.

This global mode adds a hook to `after-focus-change-function'
that runs `unfocused-hooks' iff no Emacs frame is in focus."
  :lighter " unfoc"
  :init-value nil
  :keymap nil
  :global t
  (if unfocused-mode
      (add-function :after after-focus-change-function #'unfocused-run-hooks)
    (remove-function after-focus-change-function #'unfocused-run-hooks)))

;;; unfocused.el ends here
