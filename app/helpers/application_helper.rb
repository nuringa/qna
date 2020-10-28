module ApplicationHelper
  def bootstrap_class_for_flash(type)
    case type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    when 'danger'
      'alert-danger'
    when 'warning'
      'alert-warning'
    else
      type.to_s
    end
  end
end
