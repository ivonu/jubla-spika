class SliderInput < SimpleForm::Inputs::Base
  def input(wrapper_options)

    input_min = create_input(wrapper_options, "min")
    input_max = create_input(wrapper_options, "max")
    "
      #{input_min}
      #{input_max}
      <span id='#{create_id('min_show')}'></span> -
      <span id='#{create_id('max_show')}'></span>
      #{options[:unit]}
      <div class='simpleform-slider'
        data-attribute='#{attribute_name.to_s}'
        data-min=#{options[:min]}
        data-max=#{options[:max]}
        data-setter=#{options[:setter]}
      ></div>
    ".html_safe

  end

  def create_input(wrapper_options, range)
    input_id = (create_id(range));
    input_html_options = {id: input_id}
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    return "#{@builder.hidden_field(input_id, merged_input_options)}" 
  end

  def create_id(range)
    return attribute_name.to_s + '_' + range;
  end
end