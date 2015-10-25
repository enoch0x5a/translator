class Translation < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :from_lang,
                        :to_lang,
                        :input_text,
                        :output_text
end
