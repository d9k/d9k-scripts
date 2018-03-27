(ns edit-firefox-css.core
  (:require [clojure.java.io :as io])
  (:gen-class :main true))

(require '[me.raynes.fs :as fs])
(require '[clojure-ini.core :as ini])
(require '[clojure.tools.cli :as cli])
;;(use '[clojure.java.shell :only [sh with-sh-dir]])

;;@link https://codification.wordpress.com/2012/03/06/spawn-an-external-process-in-clojure/
(require 'proc)
(use '[clojure.string :only (join split)])

(def cli-options
[["-m" "--merge" "merge settings with config repo" :flag true :default false]
 ["-h" "--help" "print help" :flag true :default false]]);

(comment
      (defn to-path[p]
        (case (type p)
          java.io.File (.getCanonicalPath p)
          java.lang.String (to-path (fs/expand-home p))
      ))
)

;;TODO return output
(defn bash [& command-parts]
  (proc/spawn "bash" "-c" (str (join " " command-parts))))

;;TODO How to def multiple vars at once?
(def editor-command "lime")
(def home (fs/expand-home "~"))
(def profiles-mozilla-path (str home "/.mozilla/firefox"))
(def profiles-ini-path (str profiles-mozilla-path "/profiles.ini"))
(def backup-cfg-folder-path (str home "/scripts/cfg/firefox"))
(def backup-cfg-path (str backup-cfg-folder-path "/userContent.css"))

(defn get-profile-from-firefox-ini
  [ini-path]
  (let [ini-map (ini/read-ini ini-path :keywordize? true, :trim? true)
        profile (first (concat
              (filter (fn [section]
                (= (get (second section) :Default) "1"))
              ini-map)
              (filter (fn [section]
                (= (get (second section) :Name) "default"))
              ini-map)
        ))]
      (get (second profile) :Path))
  )

(defn run-editor [profile-name merge]
  (let [profile-path (str profiles-mozilla-path "/" profile-name)
        user-css-folder-path (str profile-path "/chrome")
        user-css-path (str user-css-folder-path "/userContent.css")]
    (do (bash "mkdir" "-p" user-css-folder-path)
      (bash "touch" user-css-path)
      ;;(proc/spawn "bash" "-c" "sublime-text \"chrome/userContent.css\"&")
      (bash "mkdir -p " backup-cfg-folder-path)
      (bash "touch" backup-cfg-path)
      (if merge
        (bash "meld " user-css-path " " (str backup-cfg-path "&") )
        (bash "sublime-text " user-css-path " " (str backup-cfg-path "&") ))
      ))
)

(defn print-help-decorator [opts-map]
  (let [help (:help (:options opts-map))
        errors (:errors opts-map)]
    (if (or help errors)
      (do (if errors (println (str (join "\n" errors)) "\n"))
          (println (str "Available options:\n" (:summary opts-map)))
          true)
    )))


(defn main [& args] nil
  (let [opts-map (cli/parse-opts args cli-options)
        opts (:options opts-map)]
    (if-not (print-help-decorator opts-map)
      (if (fs/exists? profiles-ini-path)
        (if-let [profile-name (get-profile-from-firefox-ini profiles-ini-path)]
          (run-editor profile-name (:merge opts))
          (println "No profile-name found in" profiles-ini-path)
        )
        (println profiles-ini-path "doesn't exist")))))

(defn -main [& args] (apply main args))

