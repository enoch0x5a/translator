require 'yat'

require 'rails/all'

module YatForRails
  include YandexTranslator

  class YatForRails::Translator < YandexTranslator::Yat

    def initialize(params = {})
      format = params[:format] || :json

      super(format)
      @locale = params[:locale] || Rails.application.config.i18n.default_locale || :en
    end

    def translation_directions
      @translation_directions ||= parse_translation_directions(get_languages(ui: @locale))
    end

    alias_method :detect_language, :detect
    def detect_language(text)
      return unless (text = text)
      detect(text: text)['lang']
    end

    def translate(text, to_lang)
      text = \
        if text.kind_of? String
          text
        elsif text.respond_to? :to_s
          text.to_s
        end
      raise TypeError unless text
      return if text.empty?

      lang = \
        if to_lang.kind_of? String
          to_lang
        elsif to_lang.respond_to? :[]
          to_lang[:to]
        end
      raise TypeError unless lang

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
