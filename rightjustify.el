;;; rightjustify.el --- Right justifies the region

;; Copyright (C) 1999 by Free Software Foundation, Inc.

;; Author: Lars Clausen <lrclause@shasta.cs.uiuc.edu>
;; Keywords: convenience

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; right-justify shifts all lines to the right, to the right-most character
;; found in the region.  May untabify as a part of the process.

(require 'untabify)

;;; Code:

(defun right-justify (start end)
  (interactive "r")
  (save-excursion
    (goto-char end)
    (let ((end-mark (point-marker))
          (right-side
           (let ((maxval 0))
             (goto-char start)
             (end-of-line)
             (while (< (point) end)
               (if (> (current-column) maxval)
                   (setq maxval (current-column)))
               (end-of-line 2)
               )
             maxval)))

      (goto-char start)
      (end-of-line)
      (while (< (point) (marker-position end-mark))
        (let* ((line-end (current-column))
               (need-indent (- right-side line-end)))
          (beginning-of-line)
          (skip-syntax-forward " " (+ (point) line-end))
          (untabify (point) line-end) ;; Undo tabs in text
          (if (> need-indent 0)
              (insert (make-string need-indent ? ))))
        (end-of-line 2)
        ))))

;;; rightjustify.el ends here
