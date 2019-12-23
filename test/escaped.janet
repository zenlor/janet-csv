(import ../csv :as csv)

(def sample
``"new
lines","single
row"``)

(let [results (csv/parse
                sample)]
  (if (not= 1 (length results))
    (error "results length not valid")))

(def sample2
``"embedded ""quotes""","embedded ""quotes""","embedded ""quotes"""
"embedded ""commas,""","embedded ""commas,""","embedded ""commas,"""``)

(let [results (csv/parse sample2)]
  (if (not= 3 (length (first results)))
    (error "error while parsing double quotes"))
  (if (not= 3 (length (1 results)))
    (error "error while parsing embedded commas")))
