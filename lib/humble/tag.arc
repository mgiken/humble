; Tag Util.

(require "util.arc")

(implicit markup 'html)  ; Available markup [html|xml]

(def pr-escaped (x)
  (each c x
    (pr (case c
          #\< "&lt;"
          #\> "&gt;"
          #\& "&amp;"
          #\" "&quot;"
          #\' "&#39;"
              c))))

(def pr-tag-attrs (attrs)
  (each k (sort < keys.attrs)
    (pr " ")
    (pr-escaped:string k)
    (pr "=\"")
    (pr-escaped:attrs k)
    (pr "\"")))

(def pr-tag-open (name attrs (o close))
  (pr "<" name)
  (pr-tag-attrs attrs)
  (if (and close (is markup 'xml))
      (pr "/>")
      (pr ">")))

(def pr-tag-close (name)
  (pr "</" name ">"))

(def pr-tag (name attrs . nodes)
  (if car.nodes
      (do (pr-tag-open name attrs)
          (each n nodes pr-node.n)
          (pr-tag-close name))
      (pr-tag-open name attrs t)))

(def pr-node args
  (each node args
    (if (no node)      nil
        (acons node)   (each n node (pr-node n))
        (isa node 'fn) (pr:node)
                       (pr-escaped node))))

(mac symtag (x)
  `(sym:+ #\< ,x))

(mac raw (x)
  `(fn () ,x))

(def parse-attrs-nodes (xs)
  (if (carisa xs 'table)
      (list car.xs cdr.xs)
      (let attrs (table)
        (while (carisa xs 'sym)
          (= (attrs pop.xs) pop.xs))
        (list attrs xs))))

(mac gentag (name . body)
  (unless (bound:symtag name)
    `(def ,symtag.name args
       (let (attrs nodes) (parse-attrs-nodes args)
         ,@body
         (raw (tostring:pr-tag ',name attrs nodes))))))

(mac gentags args
  (each x args
    (eval `(gentag ,x))))

(mac extag (name . body)
  (w/uniq gargs
    `(let orig ,symtag.name
       (= ,symtag.name
          (fn ,gargs
            (let (attrs nodes) (parse-attrs-nodes ,gargs)
              ,@body
              (apply orig attrs nodes)))))))
