require 'yat'
require 'rails'
require 'i18n'

module YatForRails
  class YatForRails::Translator < YandexTranslator::Yat

    def initialize(params = {})
      format = params[:format] || :json

      super(format)
      @locale = params[:locale] || Rails.application.config.i18n.default_locale
    end

    def translation_directions
      @translation_directions ||= parse_translation_directions(get_languages(ui: @locale))
    end

    def detect(text)
      super(text: text)['lang']
    end

    def translate(text, params)
      text = text
      lang = params[:to] || detect(text)
      super(text: text, lang: lang)['text']
    end

  private
    def parse_translation_directions(t_d)
      return unless t_d['dirs']
      translation_directions = Hash.new { |hash, key| hash[key] = Array.new }

      t_d['dirs'].each do |dir|
        _, from, to = */(\w+)-(\w+)/.match(dir)
        translation_directions[from] << to
      end

      { :dirs => translation_directions, :langs => t_d['langs'] }
    end

  end
end
