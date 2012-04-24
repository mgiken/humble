(push-loadpath "lib")

(require "humble/html.arc")
(require "test.arc")

; tags -----------------------------------------------------------------------

(test isa (<p) 'fn)
(test is ((<p)) "<p>")
(test is ((<p "foo")) "<p>foo</p>")
(test isa (<div) 'fn)
(test is ((<div)) "<div>")
(test is ((<div 'id "id" "div"))
         "<div id=\"id\">div</div>")

; render-html ----------------------------------------------------------------

(test is (tostring:render-html (<html (<body (<div "foo"))))
         "<!DOCTYPE html><html><body><div>foo</div></body></html>")

(done-testing)

; vim: ft=arc
