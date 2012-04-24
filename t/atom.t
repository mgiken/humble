(push-loadpath "lib")

(require "humble/atom.arc")
(require "test.arc")

; tags -----------------------------------------------------------------------

(test isa (<author) 'fn)
(test is ((<author)) "<author>")
(test is ((<author "foo")) "<author>foo</author>")
(test is ((<feed)) "<feed xmlns=\"http://www.w3.org/2005/Atom\">")
(test is ((<feed 'xmlns "foo")) "<feed xmlns=\"foo\">")

; render-atom ----------------------------------------------------------------

(test is (tostring:render-atom (<feed (<title "foo")))
         "<?xml version=\"1.0\" encoding=\"utf-8\"?>\
<feed xmlns=\"http://www.w3.org/2005/Atom\"><title>foo</title></feed>")

(done-testing)

; vim: ft=arc
