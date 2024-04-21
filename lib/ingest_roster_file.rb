# frozen_string_literal: true

require 'csv'

class IngestRosterFile
  def confirm_unit(name, cat, parent)
    return nil if name == ''

    unit = Unit.find_by(name:, cat:)
    unit = Unit.create!(name:, cat:, parent:) if unit.nil?

    if unit.parent.nil?
      unit.parent = parent
      unit.save!
    end

    if !parent.nil? && parent != unit.parent
      puts "Skipping on #{name} #{cat} - wanting #{parent.name}, current #{unit.parent.name}"
      return nil
    end

    unit
  end

  def create_units(row)
    outfit_only =
      row['Cadet/Major Unit'] == 'CORPS Staff' ||
      row['Cadet/Major Unit'] == 'CS' ||
      row['Cadet/Unit'].include?('Staff') ||
      row['Cadet/Unit'] == 'LOA'

    if outfit_only
      confirm_unit(row['Cadet/Outfit'], 'outfit', nil)
    else
      major = confirm_unit(row['Cadet/Major Unit'], 'major', nil)
      minor = confirm_unit(row['Cadet/Minor Unit'], 'minor', major)
      confirm_unit(row['Cadet/Outfit'], 'outfit', minor)
    end
  end

  def process_roster_row(row)
    if row['Cadet/Outfit'].nil?
      puts "Skipping #{row['Cadet/Email']}"
      return
    end

    create_units(row)

    existing_user = User.find_by(email: row['Cadet/Email'])

    return { status: :error, message: "User with email #{row['Cadet/Email']} already exists." } if existing_user

    User.create!(
      email: row['Cadet/Email'],
      first_name: row['Cadet/First'],
      last_name: row['Cadet/Last'],
      uid: nil,
      provider: 'google_oauth2',
      unit: Unit.find_by!(name: row['Cadet/Outfit'], cat: 'outfit')
    )
    { status: :success }
  end

  def ingest_roster_file(file_path)
    csv = CSV.open(file_path, headers: true)
    errors = []
    csv.each do |row|
      ret = process_roster_row(row)
      errors.push(ret[:message]) if ret[:status] == :error
    end
    errors
  end
end

if __FILE__ == $PROGRAM_NAME
  base_path = 'lib/assets/Overhead - Master Cadet Roster.csv'
  base_path = Regexp.last_match(1) if Regexp.last_match(1)

  IngestRosterFile.new.ingest_roster_file(base_path)
end
