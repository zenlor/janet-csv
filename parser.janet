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

(defn- unescape-field [field]
  (string/replace-all "\"\"" "\"" field))

(defn- unescape-row [row]
  (map unescape-field row))

(defn- parse-and-clean [data]
  (->> data
       (peg/match csv-lang)
       (map unescape-row)))

(defn- headerize [ary]
  (let [header (map keyword (first ary))
        data   (array/slice ary 1)]
    (map (fn [row] (zipcoll header row))
         data)))

(defn parse [input &opt header cleanup]
  (let [data (parse-and-clean input)]
    (if header
      (headerize data)
      data)))
