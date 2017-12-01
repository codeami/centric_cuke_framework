ParameterType(
    name: 'page',
    regexp: /(.*) page/,
    transformer: -> (class_name) { class_name.to_page_class }
)

ParameterType(
    name: 'should',
    regexp: /(should not|should)/,
    transformer: -> (cond) { !cond.match?(/not/) }
)