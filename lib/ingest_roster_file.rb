
require 'csv'

def ingest_roster_file(file_path)
  csv = CSV.open(file_path, headers: true)
  csv.each do |row|
    def confirm_unit name, cat, parent
      if name == ""
        return nil
      end
      unit = Unit.find_by(name: name, cat: cat)
      if unit == nil
        unit = Unit.create(name: name, cat: cat, parent: parent)
      elsif parent != nil && unit.parent == nil
        unit.parent = parent
        unit.save!
      elsif parent != nil && parent != unit.parent
        puts "Skipping on " + name + " " + cat
        return nil
      end
      
      return unit
    end

    if row["Major Unit"] == "CORPS Staff"
      outfit = confirm_unit(row["Outfit"], "outfit",  nil)
    else
      major = confirm_unit(row["Major Unit"], "major", nil)
      minor = confirm_unit(row["Minor Unit"], "minor", major)
      outfit = confirm_unit(row["Outfit"], "outfit", minor)
    end

    
    user = User.new(
      email: row["Email"],
      first_name: row["First"],
      last_name: row["Last"],
      uid: nil,
      provider: "google_oauth2"
    )

    user.unit = Unit.find_by!(name: row["Outfit"], cat: "outfit")
    user.validate!
    user.save!
  end
end

if __FILE__ == $0
  base_path = "lib/assets/corpsRoster.csv"
  if $1
    base_path = $1
  end
  ingest_roster_file(base_path)
end
