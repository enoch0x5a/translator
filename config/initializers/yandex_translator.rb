# configuration for Yandex translator

class Translator::Application
  class << self
    attr_reader :translator

    def translator
      @translator ||= YatForRails::Translator.new
    end
  end

  YandexTranslator::configure.api_key =
      'trnsl.1.1.20150825T115444Z.00d73824cf4fe80e.7d97b17f9ab50f4d580448552ea621c23200dea2'
end
