(defproject edit-firefox-css "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [
    [org.clojure/clojure "1.6.0"]
    [me.raynes/fs "1.4.6"]
    [clojure-ini "0.0.2"]
    [org.clojure/tools.cli "0.3.1"]
  ]
;;  :main ^:skip-aot test.core
;;  :main ^:skip-aot edit-firefox-css.core
  :main edit-firefox-css.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}}
)
