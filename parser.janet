(def csv-lang
  (peg/compile
   '{:comma ","
     :space " "
     :space? (any :space)
     :cr "\r"
     :lf "\n"
     :nl (+ (* :cr :lf)
            :cr :lf)
     :dquote "\""
     :dquote? (? "\"")
     :d_dquote (* :dquote :dquote)
     :textdata (+ (<- (some (if-not (+ :dquote :comma :nl) 1)))
                  (* :dquote
                     (<- (some (+ (if :d_dquote 2)
                                  (if-not :dquote 1))))
                     :dquote))
     :field (* :space? :textdata :space?)
     :row (* (any (+ (* :field :comma)
                     :field))
             (+ :nl 0))
     :main (some (group :row))}))

(def field-unescape
  (peg/compile
   '{:dquote "\""
     :d_dquote (* :dquote :dquote)
     :main (/ :d_dquote :dquote)}))

(defn parse [input &opt header]
  (let [data (peg/match csv-lang input)]
    (if header
      (let [header (map keyword (first data))
            data (array/slice data 1)]
        (map (fn [ary] (zipcoll header ary))
             data))
     data)))
