say "Import Overlastic"
append_to_file "app/javascript/application.js", %(import "overlastic"\n)

say "Pin Overlastic"
append_to_file "config/importmap.rb", %(pin "overlastic", to: "overlastic.min.js", preload: true\n)

say "Add Overlastic tag in application layout"
insert_into_file Rails.root.join("app/views/layouts/application.html.erb"), "\n\n    <%= overlastic_tag %>", before: /\s*<\/body>/
