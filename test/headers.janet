(import ../parser :as csv)

(def sample
``h1,h2
val1,val2
val3,val4``)

(let [results (csv/parse
                sample
                true)]
  (if (not= 2 (length results))
    (error "results length not valid"))
  (if (not= "val1" ((first results) :h1))
    (error "invalid header results")))

