module ApplicationHelper
  def text_input_with_label(form, name, label)
    label = content_tag(:div, class: "col-md-4") do
      form.label name, label
    end
    
    text_input = content_tag(:div, class: "col-md-8") do
      form.text_field name, class: "form-control"
    end
    
    content_tag(:div, class: "row") { label.concat text_input }
  end
end