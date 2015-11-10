class TranslationsController < ApplicationController
  before_action :authorize, :only => [:save, :show, :update, :destroy]

  helper_method :translation,
                :language_name_for,
                :languages_select_options,
                :translations_collection

  def index
  end

  def create

    translate!
    render 'index'
  end

  def save
    if translate!
      translations_collection.create( input_text: translation.input_text,
                                      output_text: translation.output_text,
                                      from_lang: params[:auto] == 'true' ?
                                          translator.detect_language(@translation.input_text) :
                                          translation_params[:from_lang],
                                      to_lang: translation.to_lang)
    end

    render nothing: true
  end

  def show
    @translation = Translation.find(params[:id])
    render 'index'
  end

  def update
    if current_user
      @translation = Translation.find(params[:id])
      translation_params.each_pair do |param, value|
        @translation.send "#{param}=", value
      end
      @translation.update_columns( input_text: @translation.input_text,
                                   output_text: translate,
                                   from_lang: params[:auto] == 'true' ?
                                       translator.detect_language(@translation.input_text) :
                                       translation_params[:from_lang] )
    end

    redirect_to root_url
  end

  def destroy
    Translation.destroy(params[:id])
    @translation = Translation.new
    redirect_to translations_url
  end

  private
  def translations_collection
    @translations_collection ||= current_user.try(:translations)
  end

  protected
  def translation
    if params['translation']
      @translation ||= Translation.new(translation_params)
    else
      @translation ||= Translation.new
    end
  end

  def translation_params
    params.require(:translation).permit(:input_text, :output_text, :from_lang, :to_lang)
  end

  def translator
    @translator ||= Translator::Application.translator
  end

  def translation_directions
    @translation_directions ||= translator.translation_directions
  end

  def languages_select_options
    @languages_select_options ||= translation_directions[:langs].map {|k,v| [v,k]}.sort
  end

  def language_name_for(abbrev)
    translator.translation_directions[:langs][abbrev]
  end

  #TODO: get rid of this monstrosity
  def translate
    return if translation.input_text.nil? || translation.input_text.empty?
    if (auto_detect_lang = params[:auto])
      translation.from_lang = translator.detect_language(translation.input_text)
    end

    translation_direction = auto_detect_lang ? translation.to_lang : "#{translation.from_lang}-#{translation.to_lang}"
    translator.translate(translation.input_text, to: translation_direction)
  end

  alias_method :translate!, :translate
  def translate!
    translation.output_text = translate
  end
end
