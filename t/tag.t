(push-loadpath "lib")

(require "humble/tag.arc")
(require "test.arc")

; pr-escaped  -----------------------------------------------------------------

(test is (tostring:pr-escaped "<")  "&lt;")
(test is (tostring:pr-escaped ">")  "&gt;")
(test is (tostring:pr-escaped "&")  "&amp;")
(test is (tostring:pr-escaped "\"") "&quot;")
(test is (tostring:pr-escaped "'")  "&#39;")
(test is (tostring:pr-escaped "x")  "x")
(test is (tostring:pr-escaped "x<")  "x&lt;")
(test is (tostring:pr-escaped "x>")  "x&gt;")
(test is (tostring:pr-escaped "x&")  "x&amp;")
(test is (tostring:pr-escaped "x\"") "x&quot;")
(test is (tostring:pr-escaped "x'")  "x&#39;")
(test is (tostring:pr-escaped "<x")  "&lt;x")
(test is (tostring:pr-escaped ">x")  "&gt;x")
(test is (tostring:pr-escaped "&x")  "&amp;x")
(test is (tostring:pr-escaped "\"x") "&quot;x")
(test is (tostring:pr-escaped "'x")  "&#39;x")

; pr-tag-attrs ---------------------------------------------------------------

(test is (tostring:pr-tag-attrs (table)) "")
(test is
      (tostring:pr-tag-attrs (obj foo "foo"))
      " foo=\"foo\"")
(test is
      (tostring:pr-tag-attrs (obj foo "foo" bar "bar"))
      " bar=\"bar\" foo=\"foo\"")
(test is
      (tostring:pr-tag-attrs (obj foo "f&oo" bar "b<ar"))
      " bar=\"b&lt;ar\" foo=\"f&amp;oo\"")

; pr-tag-open ----------------------------------------------------------------

(test is (tostring:pr-tag-open 'foo (table)) "<foo>")
(test is (tostring:pr-tag-open 'foo (obj bar "bar")) "<foo bar=\"bar\">")
(test is (tostring:pr-tag-open 'foo (obj bar "bar") t) "<foo bar=\"bar\">")
(w/markup 'html
  (test is (tostring:pr-tag-open 'foo (obj bar "bar") t)
            "<foo bar=\"bar\">"))
(w/markup 'xml
  (test is (tostring:pr-tag-open 'foo (obj bar "bar") t)
            "<foo bar=\"bar\"/>"))

; pr-tag-close ---------------------------------------------------------------

(test is (tostring:pr-tag-close 'foo) "</foo>")

; pr-tag ---------------------------------------------------------------------

(test is (tostring:pr-tag 'foo (table) nil) "<foo>")
(test is (tostring:pr-tag 'foo (table) "") "<foo></foo>")
(test is (tostring:pr-tag 'foo (table) "bar") "<foo>bar</foo>")
(test is (tostring:pr-tag 'foo (obj bar "bar") nil)
          "<foo bar=\"bar\">")
(test is (tostring:pr-tag 'foo (obj bar "bar") "")
          "<foo bar=\"bar\"></foo>")
(test is (tostring:pr-tag 'foo (obj bar "bar") "bar")
          "<foo bar=\"bar\">bar</foo>")

; pr-node --------------------------------------------------------------------

(test is (tostring:pr-node nil) "")
(test is (tostring:pr-node "foo") "foo")
(test is (tostring:pr-node "f&oo") "f&amp;oo")
(test is (tostring:pr-node "foo" "bar") "foobar")
(test is (tostring:pr-node "f&oo" "bar") "f&amp;oobar")
(test is (tostring:pr-node (fn () "foo")) "foo")
(test is (tostring:pr-node (fn () ">foo")) ">foo")
(test is (tostring:pr-node "foo" (fn () ">foo") "b'az") "foo>foob&#39;az")

; symtag ---------------------------------------------------------------------

(test is (symtag 'foo) '<foo)

; raw  -----------------------------------------------------------------------

(test isa (raw "foo") 'fn)
(test is ((raw "foo")) "foo")

; parse-attrs-nodes ----------------------------------------------------------

(test iso (parse-attrs-nodes (list 'foo "foo" 'bar "bar" "baz"))
          (list (obj foo "foo" bar "bar") (list "baz")))
(test iso (parse-attrs-nodes (list 'foo "foo" 'bar "bar" "baz" "foobar"))
          (list (obj foo "foo" bar "bar") (list "baz" "foobar")))
(test iso (parse-attrs-nodes (list (obj foo "foo" bar "bar") "baz"))
          (list (obj foo "foo" bar "bar") (list "baz")))
(test iso (parse-attrs-nodes (list (obj foo "foo" bar "bar") "baz" "foobar"))
          (list (obj foo "foo" bar "bar") (list "baz" "foobar")))
(test iso (parse-attrs-nodes (list "foo"))
          (list (table) (list "foo")))
(test iso (parse-attrs-nodes (list "foo" "bar"))
          (list (table) (list "foo" "bar")))

; deftag ---------------------------------------------------------------------

(deftag foo)
(test isa (<foo) 'fn)
(test is ((<foo)) "<foo>")
(test is ((<foo nil)) "<foo>")
(test is ((<foo "")) "<foo></foo>")
(test is ((<foo "bar")) "<foo>bar</foo>")
(test is ((<foo 'bar "bar" "baz")) "<foo bar=\"bar\">baz</foo>")
(test is ((<foo 'bar "&bar" "<baz")) "<foo bar=\"&amp;bar\">&lt;baz</foo>")
(test is ((<foo 'bar "&bar" (raw "<baz"))) "<foo bar=\"&amp;bar\"><baz</foo>")

; deftags --------------------------------------------------------------------

(deftags x y z)
(test isa (<x) 'fn)
(test isa (<y) 'fn)
(test isa (<z) 'fn)
(test is ((<x "x")) "<x>x</x>")
(test is ((<y "y")) "<y>y</y>")
(test is ((<z "z")) "<z>z</z>")

; extag ----------------------------------------------------------------------

(extag foo (= attrs!bar "bar"))
(test isa (<foo) 'fn)
(test is ((<foo)) "<foo bar=\"bar\">")
(test is ((<foo "")) "<foo bar=\"bar\"></foo>")

(extag foo (push "baz" nodes))
(test isa (<foo) 'fn)
(test is ((<foo)) "<foo bar=\"bar\">baz</foo>")
(test is ((<foo "")) "<foo bar=\"bar\">baz</foo>")
(test is ((<foo "baz")) "<foo bar=\"bar\">bazbaz</foo>")

(done-testing)

; vim: ft=arc
