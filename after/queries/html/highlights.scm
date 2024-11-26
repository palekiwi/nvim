; extends

((attribute_name) @constant
    (#match? @constant "data-action|controller"))

((attribute_name) @markup.strong
    (#match? @markup.strong "data-controller"))

((attribute_name) @constant
    (#match? @constant "data-.*-outlet|value|target"))

((attribute (attribute_name) @constant
    ((#match? @constant "data-controller")
    (quoted_attribute_value
    (attribute_value) @markdown.strong))))
