; extends

((apply_expression
   function: (apply_expression
     function: (select_expression
       attrpath: (attrpath
         attr: (identifier) @_func)))
   argument: (indented_string_expression
     (string_fragment) @injection.content))
 (#any-of? @_func "writeNu" "writeNuBin")
 (#set! injection.language "nu")
 (#set! injection.combined))
