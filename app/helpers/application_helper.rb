module ApplicationHelper
  def custom_error_messages_for(object)
    object.errors.full_messages.map do |msg|
      msg.sub("#{object.class.human_attribute_name(:name)} ", '')
    end
  end
end
