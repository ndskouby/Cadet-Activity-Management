# frozen_string_literal: true

require 'csv'

def confirm_unit(name, cat, parent)
  return nil if name == ''

  unit = Unit.find_by(name:, cat:)
  unit = Unit.create(name:, cat:, parent:) if unit.nil?

  if unit.parent.nil?
    unit.parent = parent
    unit.save!
  end

  if !parent.nil? && parent != unit.parent
    puts "Skipping on #{name} #{cat}"
    return nil
  end

  unit
end

def create_units(row)
  if row['Major Unit'] == 'CORPS Staff'
    confirm_unit(row['Outfit'], 'outfit', nil)
  else
    major = confirm_unit(row['Major Unit'], 'major', nil)
    minor = confirm_unit(row['Minor Unit'], 'minor', major)
    confirm_unit(row['Outfit'], 'outfit', minor)
  end
end

def ingest_roster_file(file_path)
  csv = CSV.open(file_path, headers: true)
  csv.each do |row|
    create_units(row)

    User.create(
      email: row['Email'],
      first_name: row['First'],
      last_name: row['Last'],
      uid: nil,
      provider: 'google_oauth2',
      unit: Unit.find_by!(name: row['Outfit'], cat: 'outfit')
    )
  end
end

if __FILE__ == $PROGRAM_NAME
  base_path = 'lib/assets/corpsRoster.csv'
  base_path = Regexp.last_match(1) if Regexp.last_match(1)
  ingest_roster_file(base_path)
end
