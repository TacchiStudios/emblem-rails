require 'emblem/rails/template'

module Emblem
  module Rails
    class Engine < ::Rails::Engine
      initializer "ember_rails.setup", :after => :append_assets_path, :group => :all do |app|
        app.config.assets.configure do |env|
          if env.respond_to?(:register_transformer)
            env.register_mime_type 'text/js', extensions: ['.js'], charset: :js
            env.register_preprocessor 'text/emblem', Emblem::Rails::Template
          elsif env.respond_to?(:register_engine)
            args = ['.emblem', Emblem::Rails::Template]
            args << { mime_type: 'text/js', silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
            env.register_engine(*args)
          end
        end
      end
    end
  end
end
