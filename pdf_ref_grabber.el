;;; pdf_ref_grabber.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024
;;
;; Author:  <juraph>
;; Maintainer:  <juraph>
;; Created: September 17, 2024
;; Modified: September 17, 2024
;; Version: 0.0.1
;; Keywords: pdf bibtex zotero bib
;; Homepage: https://github.com/juraph/pdf_ref_grabber
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;; Zotero

(require 'url)
(require 'zotero)
(require 'zotero-json)
(require 'zotero-recognize)

(defcustom bib_loc "~/.org/papers.bib" "Location of the bibliography to write to" :type 'string)
(defcustom pdf_location "~/Documents/papers/" "Location to store the PDF files in" :type 'string)
(defcustom paper_list_location " ~/.org/2024/papers.org" "Location of the paper list org-file" :type 'string)

(defun my/organise_pdf()
  "Organize PDF: rename, copy to papers directory,
 create bibtex entry, and add to papers.org."
  (interactive)
  (message "organising pdf")
  (if (eq major-mode 'pdf-view-mode)
      (let* ((original-file (buffer-file-name))
             (url (concat zotero-recognize-base-url "/recognize"))
             (headers '(("Content-Type" . "application/json")))
             (data (zotero-recognize--pdftojson original-file))
             (response (zotero-dispatch (zotero-request-create :method "POST"
                                                               :url url
                                                               :headers headers
                                                               :data data)))
             (resp (zotero-response-data response))
             (title (plist-get resp :title))
             (authors (plist-get resp :authors))
             (year (or (plist-get resp :year) (format-time-string "%Y")))
             (abstract (plist-get resp :abstract))
             ;; (cleaned-title (replace-regexp-in-string "[^a-zA-Z0-9]+" "_" title))
             ;; (new-filename (concat cleaned-title ".pdf"))
             (papers-dir "~/Documents/papers/")
             (first-author-last (plist-get (aref authors 0) :lastName))
             (citation-key (format "%s%s_%s"
                                   (downcase first-author-last)
                                   (substring year -2)
                                   (mapconcat
                                    (lambda (word) (downcase (substring word 0 (min 6 (length word)))))
                                    (split-string title "[^[:alnum:]]+")
                                    "_")))
             (new-file-path (expand-file-name (concat citation-key ".pdf") papers-dir))
             (bibtex-entry (format "@article{%s,
  title = {%s},
  author = {%s},
  abstract = {%s},
  year = {%s},
  file = {%s}
}"
                                   citation-key
                                   title
                                   (mapconcat (lambda (author)
                                                (format "%s, %s"
                                                        (plist-get author :lastName)
                                                        (plist-get author :firstName)))
                                              authors " and ")
                                   ;; bib_loc
                                   abstract
                                   year
                                   new-file-path)))
        ;; Add bibtex entry
        (with-current-buffer (find-file-noselect bib_loc)
          (goto-char (point-max))
          (insert "\n" bibtex-entry "\n")
          (save-buffer))

        ;; Add entry to papers.org
        (with-current-buffer (find-file-noselect paper_list_location)
          (goto-char (point-max))
          (insert (format "** TODO (cite:%s) %s\n" citation-key title))
          (save-buffer))

        ;; Rename and copy PDF
        (copy-file original-file new-file-path t)

        (message "PDF organized, bibtex entry created, and added to papers.org"))
    (message "Not viewing a PDF file.")))


(provide 'pdf_ref_grabber)
;;; pdf_ref_grabber.el ends here
