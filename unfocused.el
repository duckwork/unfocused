;;; unfocused.el --- Run code when unfocused -*- lexical-binding: t -*-

;; Copyright (C) 2021 Case Duckworth
;; This file can be freely used, reused, modified and distributed under
;; the terms of the ISC License.

;; This file is NOT part of GNU Emacs.

;; Author: Case Duckworth <acdw@acdw.net>
;; SPDX-License-Identifier: ISC
;; Version: 0.1
;; Package-Requires: ((emacs "27.1"))
;; Keywords: frames convenience
;; URL: https://github.com/duckwork/unfocused

;;; Commentary:

;; Emacs 27 changed `focus-out-hook' to the (I'm sure better, but nonetheless
;; more complicated) `after-focus-change-function', which is also more
;; verbose.  `unfocused' implements a mode that brings back the old
;; easy-to-write functionality, with a twist: `unfocused-mode' only runs its
;; hook when /all/ Emacs frames are unfocused, instead of when any of them
;; are.  Does it make that much of a difference?  I'm arguing "no."  If you
;; think it does, this package may not be for you -- after all, it's easy
;; enough to add a function to `after-focus-change-function'.

;;; Code:

(defcustom unfocused-hook nil
  "Normal hook run when all frames are unfocused."
  :type 'hook
  :group 'frames)

(defun unfocused-run-hooks ()
  "Run hooks in `unfocused-hook' when no frames are focused."
  (when (seq-every-p #'null (mapcar #'frame-focus-state (frame-list)))
    (run-hooks 'unfocused-hook)))

;;;###autoload
(define-minor-mode unfocused-mode
  "Toggle addition of `unfocused-hook' to `after-focus-change-function'.
This global mode adds a hook to `after-focus-change-function'
that runs `unfocused-hook' iff no Emacs frame is in focus."
  :lighter " unfoc"
  :init-value nil
  :keymap nil
  :global t
  :group 'frames
  (if unfocused-mode
      (add-function :after after-focus-change-function #'unfocused-run-hooks)
    (remove-function after-focus-change-function #'unfocused-run-hooks)))

(provide 'unfocused)
;;; unfocused.el ends here
