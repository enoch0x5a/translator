$( ->
  $("#save_btn").on('click', ->
    $.post("translations/save", {
      'translation[input_text]' : $("textarea#translation_input_text")[0].value,
      'translation[output_text]' : $("textarea#translation_output_text")[0].value,
      'translation[from_lang]' : $("select#translation_from_lang")[0].value,
      'translation[to_lang]' : $("select#translation_to_lang")[0].value
    })
    document.location = document.location
  )
)
