say "Add Overlastic JS include tag in application layout"
insert_into_file Rails.root.join("app/views/layouts/application.html.erb"), "\n    <%= javascript_include_tag \"overlastic.min\", \"data-turbo-track\": \"reload\", defer: true %>", before: /\s*<\/head>/

say "Add Overlastic tag in application layout"
insert_into_file Rails.root.join("app/views/layouts/application.html.erb"), "\n\n    <%= overlastic_tag %>", before: /\s*<\/body>/
