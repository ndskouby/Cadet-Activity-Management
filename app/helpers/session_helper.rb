# frozen_string_literal: true

module SessionHelper
  def find_or_create_user(auth)
    User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.email = auth['info']['email']
      names = auth['info']['name'].split
      u.first_name = names[0]
      u.last_name = names[1..].join(' ')

      # Making the default Minor Unit point to a Dummy entry
      # for the time being, since the audit system isn't up yet.
      u.unit = Unit.find_by(name: 'Unassigned Outfit')
    end
  end
end
