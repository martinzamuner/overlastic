def run_overlastic_install_template(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb", __dir__)}"
end

namespace :overlastic do
  desc "Install Overlastic into the app"
  task :install do
    if Rails.root.join("config/importmap.rb").exist?
      Rake::Task["overlastic:install:importmap"].invoke
    else
      Rake::Task["overlastic:install:node"].invoke
    end
  end

  namespace :install do
    desc "Install Overlastic into the app with asset pipeline"
    task :importmap do
      run_overlastic_install_template "overlastic_with_importmap"
    end

    desc "Install Overlastic into the app with node"
    task :node do
      run_overlastic_install_template "overlastic_with_node"
    end
  end
end
