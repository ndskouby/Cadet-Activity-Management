# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@cadetcorp.com'
  layout 'mailer'
end
