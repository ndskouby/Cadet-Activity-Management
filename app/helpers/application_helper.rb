# frozen_string_literal: true

module ApplicationHelper
  def custom_error_messages_for(object)
    object.errors.full_messages.map do |msg|
      msg.sub("#{object.class.human_attribute_name(:name)} ", '')
    end
  end

  def badge_color_for_status(status)
    case 
    when status.downcase.include?('pending')
      'bg-warning'
    when status.downcase.include?('approved')
      'bg-success'
    when status.downcase.include?('rejected')
      'bg-danger'
    when status.downcase.include?('revision')
      'bg-info'
    else
      'bg-light text-dark'
    end
  end
  
end
