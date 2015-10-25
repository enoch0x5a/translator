require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Translator
  class Application < Rails::Application

    class << self
      attr_accessor :translator, :translation_directions
    end
        
    def parse_translation_directions(t_d)
      translation_directions = Hash.new { |hash, key| hash[key] = Array.new }
      
      t_d["dirs"].each do |dir|
        from, from, to = */(\w+)-(\w+)/.match(dir)
        translation_directions[from] << to
      end

      { "dirs" => translation_directions, "langs" => t_d["langs"]}
    end

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :ru
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Moscow'
    
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    YandexTranslator::configure.api_key = ''

    self.translator = YandexTranslator::Yat.new(:json)
    
    self.translation_directions =
      parse_translation_directions(self.translator.get_languages(ui: config.i18n.default_locale))
  
  end
end
