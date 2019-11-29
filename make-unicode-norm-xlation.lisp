#!/usr/local/bin/lispscript


; « (defvar /INPUTPREFIX/ Ø (cadr (cmdargs)))
;     or die "no input prefix" »

(defvar /INPUTPREFIX/ "/home/tony/Music/")

(defvar /FINDCOMMAND/ (fn "find ~A -type f" /INPUTPREFIX/))

(defvar /huge-holder/ (make-hash-table :test #'equal))

(declaim (inline nfc-it))
(defun nfc-it (it)
  (sb-unicode:normalize-string it :nfc))


(for-each/list (zsh /FINDCOMMAND/ :split t)
  (setq value! (~r value! (fn •^~A• /INPUTPREFIX/) ""))
  (ft "~A~%" value!)
  (let ((better (nfc-it value!)))
    (setf (gethash better /huge-holder/) value!)))


(with-a-file "xlation-table.lisp" :w
  (print /huge-holder/ stream!))

