(import ../csv :as csv)

(def sample
 ``"new ""doublyquoted word""","double ""doublequote"""``)

(let [results (csv/parse sample)]
  (each row results
    (each field row
      (when
          (string/find "\"\"" field)
        (error "fields contains double doublequotes")))))
