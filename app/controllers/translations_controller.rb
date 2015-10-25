class TranslationsController < TranslateController
  before_action :authorize, :only => [:save, :show, :update]

  helper_method :translation,
                :translation_directions,
                :translations_collection,
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
    translation.output_text = translate(@translation.input_text, params[:auto])
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
  def translation_params
    params.require(:translation).permit(:input_text, :output_text, :from_lang, :to_lang)
  end

  def translation(id = nil)
    if params['translation']
      @translation ||= Translation.new(translation_params)
    else
      @translation ||= Translation.new
    end
  end

  def resource_translator
    @resource_translator ||= Translator::Application.translator
  end

  def translations_collection
    @translations_collection ||= current_user.try(:translations)
  end

  def translation_directions
    @translation_directions ||= Translator::Application.translation_directions
  end

  def determine_lang(text)
    resource_translator.detect(text: text)['lang']
  end

  def languages_select_options
    translation_directions['langs'].map {|k,v| [v,k]}.sort
  end

  def back_or_default(default = root_path)
    request.referer.present? ? :back : default
  end

  def language_name_for(abbrev)
    translation_directions['langs'][abbrev]
  end

  def translate(text, auto_lang = nil)
    resource_translator.translate(
      text: translation.input_text,
      lang: auto_lang ? "#{translation.to_lang}" :
        "#{translation.from_lang}-#{translation.to_lang}"
    )['text']
  end
  
end
