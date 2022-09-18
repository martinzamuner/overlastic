Overlastic.configure do |config|
  config.append_turbo_stream do
    turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
  end
end
