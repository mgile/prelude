(defun ppjson ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -mjson.tool" (current-buffer) t)))

                                        ;;s(define-key json-mode-map (kbd "C-c C-f") 'beautify-json)

