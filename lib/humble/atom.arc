; Atom tags.

(require "humble/tag.arc")

(deftag feed
  (or= attrs!xmlns "http://www.w3.org/2005/Atom"))

(deftags
  author
  category content contributor
  entry
  generator
  icon id
  link logo
  name
  published
  rights
  source subtitle summary
  title
  updated)

(mac render-atom args
  `(w/markup 'xml
     (pr "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
     (pr-node ,@args)))
