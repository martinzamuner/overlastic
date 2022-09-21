<h1 align="center">
  <br>
  <img src="assets/logo.svg" alt="Overlastic" width="150">
  <br>
  Overlastic
  <br>
</h1>

<h3 align="center">Fantastically easy overlays using <a href="https://hotwired.dev/" target="_blank">Hotwire</a>.</h3>

<p align="center">
  <img alt="Build" src="https://img.shields.io/github/workflow/status/martinzamuner/overlastic/CI">
  <img alt="Gem" src="https://img.shields.io/gem/v/overlastic">
  <img alt="rails version" src="https://img.shields.io/badge/rails-%3E%3D%206.1.0-informational">
  <img alt="turbo-rails version" src="https://img.shields.io/badge/turbo--rails-%3E%3D%201.2.0-informational">
  <img alt="License" src="https://img.shields.io/github/license/martinzamuner/overlastic">
</p>

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
<%= link_to_dialog "Open dialog", edit_article_path, overlay: :last %>
<%= link_to_dialog "Open dialog", edit_article_path, overlay: :first %>
```

By default, links and forms inside an overlay will drive the entire page (target _top). To keep navigation within the overlay you can set its target to _self:

```erb
<%= link_to_dialog "Open dialog", edit_article_path, overlay_target: :_self %>
```

To break out of an overlay with target _self you can use:

```erb
<%= link_to "Open whole page", edit_article_path, overlay: false %>
```

A common use case is to render a form inside an overlay. When the form is submitted, you'll validate the data and redirect to a different page if it's successful or render the form again with errors. Overlastic will handle both cases gracefully without any modifications:

```rb
if @article.save
  redirect_to article_url(@article), status: :see_other
else
  render :new, status: :unprocessable_entity
end
```

In case the form overlay was nested inside another overlay, you could prefer to apply the redirection to the parent overlay:

```rb
redirect_to article_url(@article), overlay: :previous, status: :see_other
```

### Intermediate features

<details>
  <summary>Adapting a view using the overlay variant</summary><br>

  Sometimes, you may want to alter the content of a view depending on whether it's inside an overlay or not. Overlastic defines a new `:overlay` request variant that you can use to create custom views like `new.html+overlay.erb` or inside a controller like so:

  ```rb
  respond_to do |format|
    format.turbo_stream.overlay { render :custom_view }
    format.turbo_stream.any
    format.html
  end
  ```
</details>

<details>
  <summary>Closing an overlay from the server</summary><br>

  If you don't need to render any more content you can also close an overlay from the server:

  ```rb
  if request.variant.overlay?
    close_overlay
    # close_overlay :last
    # close_overlay :all
    # close_overlay :overlay2
  else
    redirect_to articles_url, status: :see_other
  end
  ```
</details>

### Advanced features

<details>
  <summary>Appending Turbo Streams to close_overlay</summary><br>

  Sometimes, you may want not only to close an overlay, but also to deliver some other page change using a Turbo Stream:

  ```rb
  close_overlay do
    turbo_stream.prepend("flash-messages", "Deleted!")
  end
  ```
</details>

<details>
  <summary>Appending Turbo Streams to every response</summary><br>

  Overlastic can be configured to append a Turbo Stream to every response that contains an overlay.
  This can be very useful for rendering flash messages:

  ```rb
  Overlastic.configure do |config|
    config.append_turbo_stream do
      turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
    end
  end
  ```

  Then you'd only need to specify a flash message when closing an overlay, or redirecting to a different path:

  ```rb
  close_overlay notice: "Deleted!"

  # or

  redirect_to articles_path, notice: "Deleted!", status: :see_other
  ```
</details>

<details>
  <summary>Rendering an overlay without an initiator</summary><br>

  Overlastic extends the `render` method inside a controller to add all the same options as `link_to_overlay`. This allows you to force an action to render an overlay, even if it wasn't requested:

  ```rb
  render :new, overlay: :first, overlay_target: :_self, overlay_args: { title: "New article" }
  # render :edit, overlay: :last, overlay_type: :pane
  ```
</details>


## Configuration

```rb
# config/initializers/overlastic.rb

Overlastic.configure do |config|
  config.overlay_types = %i[dialog pane]
  config.default_overlay = :dialog # Options: One of the defined overlay types
  config.default_action = :stack # Options: :stack, :replace_last, :replace_all
  config.default_target = :_top # Options: :_top, :_self

  # You can define a custom partial for each overlay type
  config.dialog_overlay_view_path = "overlays/dialog"
  config.pane_overlay_view_path = "overlays/pane"

  # You can append Turbo Streams to every response containing an overlay
  config.append_turbo_stream do
    turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
  end
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
