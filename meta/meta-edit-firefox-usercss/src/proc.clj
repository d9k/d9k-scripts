(ns proc
  (:import [java.lang ProcessBuilder])
  (:use [clojure.java.io :only [reader writer]]))

(defn spawn
  "@link https://codification.wordpress.com/2012/03/06/spawn-an-external-process-in-clojure/"
  [& args]
  (let [process (-> (ProcessBuilder. args)
                  (.start))]
    {:out (-> process
            (.getInputStream)
            (reader))
     :err (-> process
            (.getErrorStream)
            (reader))
     :in (-> process
           (.getOutputStream)
           (writer))
     :process process}))
