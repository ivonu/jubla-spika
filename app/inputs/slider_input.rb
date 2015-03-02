class SliderInput < SimpleForm::Inputs::Base
  def input(wrapper_options)

    wrapper_options = {class: 'simpleform-slider-value'}

    input_min = create_input(wrapper_options, "min")
    input_max = create_input(wrapper_options, "max")

    "
      #{input_min} -
      #{input_max}
      <div class='simpleform-slider'
        data-attribute='#{attribute_name.to_s}'
        data-min=20
        data-max=40
      ></div>
    ".html_safe

  end

  def create_input(wrapper_options, range)
    input_id = (attribute_name.to_s + '_' + range);
    input_html_options = {id: input_id}
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    return "#{@builder.text_field(input_id, merged_input_options)}" 
  end
end