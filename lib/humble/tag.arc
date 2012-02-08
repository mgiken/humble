; Tag Util.

(require "util.arc")

(implicit markup 'html)  ; Available markup [html|xml]

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

(mac deftag (name (attrs children) . body)
  `(def ,symtag.name args
     (let (,attrs ,children) parse-attrs-nodes.args
       (list ,@body))))

(mac gentag (name . body)
  (unless (bound:symtag name)
    `(deftag ,name (attrs children)
       (do ,@body
           (raw (tostring:pr-tag ',name attrs children))))))

(mac gentags args
  (each x args
    (eval `(gentag ,x))))

(mac extag (name . body)
  (w/uniq gargs
    `(let orig ,symtag.name
       (= ,symtag.name (fn ,gargs
                         (let (attrs children) (parse-attrs-nodes ,gargs)
                           ,@body
                           (orig attrs children)))))))

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
  (each (k v) attrs
    (pr " ")
    (pr-escaped:string k)
    (pr "=\"")
    (pr-escaped v)
    (pr "\"")))

(def pr-tag-open (name attrs (o close))
  (pr "<" name)
  (pr-tag-attrs attrs)
  (if (and close (is markup 'xml))
      (pr "/>")
      (pr ">")))

(def pr-tag-close (name)
  (pr "</" name ">"))

(def pr-tag (name attrs children)
  (if children
      (do (pr-tag-open name attrs)
          (each c children pr-node.c)
          (pr-tag-close name))
      (pr-tag-open name attrs t)))

(def pr-node (node)
  (if (no node)      nil
      (acons node)   (each n node (pr-node n))
      (isa node 'fn) (pr:node)
                     (pr-escaped node)))
