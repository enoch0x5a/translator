class TranslationsController < ApplicationController
  before_action :authorize, :only => [:save, :show, :update]

  helper_method :translation,
                :translation_directions,
                :language_name_for,
                :languages_select_options

  def index
    render 'new'
  end

  def new

  end

  def create
    auto_lang = params[:auto]

    translation.output_text = translate(translation.input_text)
    translation.from_lang =
      auto_lang == 'true' ? determine_lang(translation.input_text) : translation.from_lang
    render 'new'
  end

  def save
    translation.output_text = translate(params[:auto])
    current_user.try(:translations).create(input_text: @translation.input_text,
                                           output_text: @translation.output_text,
                                           from_lang: @translation.from_lang,
                                           to_lang: @translation.to_lang)
    render plain: 'ok'
  end

  def show
    @translation = Translation.find(params[:id])
    render 'new'
  end

  def update
    if current_user
      @translation = Translation.find(params[:id])
      translation_params.each_pair do |param, value|
        @translation.send "#{param}=", value
      end
      @translation.update_columns( input_text: @translation.input_text,
                                   output_text: translate(@translation.input_text),
                                   from_lang: params[:auto] == 'true' ?
                                       determine_lang(@translation.input_text) :
                                       translation_params[:from_lang] )
    end

    redirect_to root_path
  end

  def destroy
    Translation.destroy(params[:id])
    @translation = Translation.new
    redirect_to :back
  end

  def dirs
    render json: translation_directions
  end

private
  def translation
    @translation ||= Translation.new
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

  def determine_lang(text)
    translator.detect(text: text)
  end

  def languages_select_options
    translation_directions[:langs].map {|k,v| [v,k]}.sort
  end

  def language_name_for(abbrev)
    translation_directions[:langs][abbrev]
  end

  def translate(auto_lang = nil)
    output_language = auto_lang ? translation.to_lang : "#{translation.from_lang}-#{translation.to_lang}"
    translator.translate @translation.input_text, to: output_language
  end
end
