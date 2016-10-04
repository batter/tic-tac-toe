desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -I lib -r ./config/environment.rb'
end

namespace :assets do
  desc "Precompile the assets"
  task :precompile do
    require File.expand_path('../config/environment', __FILE__)
    App.compile_assets
  end

  task :clean do
    system 'rm public/assets/*.css'
    system 'rm public/assets/*js'
  end
end
