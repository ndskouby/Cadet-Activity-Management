# frozen_string_literal: true

module SessionHelper
  def find_or_create_user(auth)
    # User already set up?
    u = User.find_by(uid: auth['uid'], provider: auth['provider'])
    return u if u

    # User pre-loaded in the database, but not set up for authentication yet?
    # Not sure if this is secure or not
    u = check_preloaded_database(auth)
    return u if u

    # User never seen before?
    create_new_user(auth)
  end

  def check_preloaded_database(auth)
    u = User.find_by(email: auth['info']['email'])
    return unless u
    raise 'email already associated with a uid??' if u.uid

    u.uid = auth['uid']
    u.provider = auth['provider']
    u
  end

  def create_new_user(auth)
    names = auth['info']['name'].split
    User.create!(
      uid: auth['uid'], provider: auth['provider'],
      email: auth['info']['email'],
      first_name: names[0],
      last_name: names[1..].join(' '),
      unit: Unit.find_by(name: 'Unassigned Outfit')
    )
  end
end
