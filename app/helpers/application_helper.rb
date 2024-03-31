# frozen_string_literal: true

module ApplicationHelper
  def custom_error_messages_for(object)
    object.errors.full_messages.map do |msg|
      msg.sub("#{object.class.human_attribute_name(:name)} ", '')
    end
  end

  def badge_color_for_status(status)
    if status.downcase.include?('pending')
      'bg-warning'
    elsif status.downcase.include?('approved')
      'bg-success'
    elsif status.downcase.include?('rejected')
      'bg-danger'
    elsif status.downcase.include?('revision')
      'bg-info'
    else
      'bg-light text-dark'
    end
  end
end
