(import ../csv :as csv)

(def sample
``h1,h2,h3
,val2,
"",val2,""
,,val3``)

(let [results (csv/parse
                sample
                true)]
  (pp results)
  (if (not= 3 (length results))
    (error "results length not valid"))
  (loop [row :in results]
    (if (not= 3 (length row))
      (error "resulting row is not valid"))))
