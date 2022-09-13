# Overlastic

Load any page inside an overlay (dialog modal, slide-out pane, or whatever else floats your boat). As easy as replacing `link_to` with `link_to_dialog`.


## Installation

This gem requires a modern Rails application running [turbo-rails](https://github.com/hotwired/turbo-rails). It supports both import map and node setups.

1. Add the `overlastic` gem to your Gemfile: `gem "overlastic"`
2. Run `./bin/bundle install`
3. Run `./bin/rails overlastic:install`


## Usage

Most of the time you'll just need to replace a `link_to` with one of the overlay helpers:

```erb
<%= link_to_dialog "Open dialog", edit_article_path %>
<%= link_to_pane "Open slide-out pane", edit_article_path %>
<%= link_to_overlay "Open default overlay type", edit_article_path %>
<%= link_to_overlay "Open dialog", edit_article_path, overlay_type: :dialog %>
```

They work just as `link_to` and accept the same options. You can also pass locals to the overlay view:

```erb
<%= link_to_dialog "Open dialog", edit_article_path, overlay_args: { title: "Dialog title" } %>
```

Nested overlays will stack on top of each other. You can instead replace the last one or the whole stack:

```erb
<%= link_to_dialog "Open dialog", edit_article_path, overlay_action: :replace_last %>
<%= link_to_dialog "Open dialog", edit_article_path, overlay_action: :replace_all %>
```

By default, links and forms inside an overlay will drive the entire page (target _top). To keep navigation within the overlay you can set its target to _self:

```erb
<%= link_to_dialog "Open dialog", edit_article_path, overlay_target: :_self %>
```

Sometimes, you may want to alter the content depending on whether it's inside an overlay or not. Overlastic defines a new `:overlay` request variant that you can use to create custom partials like `_form.html+overlay.erb` or inside a controller like so:

```rb
respond_to do |format|
  format.html.overlay { render :custom_view }
  format.html
end
```


## Configuration

```rb
# config/initializers/overlastic.rb

Overlastic.configure do |config|
  config.overlay_types = %i[dialog pane]
  config.default_overlay = :dialog
  config.default_action = :stack

  # You can define a custom partial for each overlay type
  config.dialog_overlay_view_path = "shared/overlays/dialog"
  config.dialog_overlay_view_path = "shared/overlays/pane"
end
```


## Customization

Overlastic comes with default views for both the dialog and pane overlays. It also provides a generator to allow for easy customization.

<details>
  <summary>Default overlays</summary><br>

  <img src="assets/dialog.png?sanitize=true" width="600" alt="Dialog">

  <br>

  <img src="assets/pane.png?sanitize=true" width="600" alt="Dialog">
</details>

<details>
  <summary>Generate customizable views</summary><br>

  ```sh
    # Available options: inline, tailwind
    ./bin/rails generate overlastic:views --css tailwind
  ```
</details>


## Development

<details>
  <summary>Roadmap</summary><br>

  - Handle 4xx responses (p.e. validation errors) when submitting forms inside an overlay
</details>

<details>
  <summary>Running the demo application</summary><br>

  - First you need to install dependencies with `bundle && yarn && yarn build`
  - Then you need to setup the DB with `./bin/rails db:migrate`
  - Lastly you can run the demo app with `./bin/rails server --port 3000`
</details>

<details>
  <summary>Running the tests</summary><br>

  - You can run the whole suite with `./bin/test`
</details>


## License

Overlastic is released under the [MIT License](https://opensource.org/licenses/MIT).
