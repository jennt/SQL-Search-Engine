class Sighting

require 'csv'
require 'pg'

data_file = 'data/sample_data.tsv'
conn = PG.connect(dbname: 'UFO')

def initialize(options)
  @id = nil
  @date = options['date']
  @location = options['location']
  @description = options['description']
end

def self.create_table
  conn = PG.connect(dbname: 'UFO')
  conn.exec("SET client_min_messages TO WARNING;")

  begin
    conn.exec("CREATE TABLE IF NOT EXISTS sightings (id SERIAL PRIMARY KEY NOT NULL, date date, location varchar, description varchar);")
    true
  rescue PG.DuplicateTable
    false
  end
  conn.close
end

def exists_already?(sighting)
  date = sighting['date']
  location = sighting['location']
  description = sighting['description']
  conn = PG.connect(dbname: 'UFO')
  result = conn.exec_params("SELECT * FROM sightings WHERE date = $1 AND location = $2 AND description = $3", [date, location, description])
  conn.close
  result.num_tuples > 0
end

def save_sighting
  conn = PG.connect(dbname: 'UFO')
  conn.exec_params("INSERT INTO sightings (date, location, description) VALUES ($1, $2, $3);", [@date, @location, @description])
  conn.close
end

def self.load_file(data_file) #, conn)
  CSV.foreach(data_file, col_sep: "\t") do |row|
    date = row[1]
    location = row[2]
    description = row[5]

    sighting = {
      'date' => date,
      'location' => location,
      'description' => description
    }

    if
      !Sighting.exists_already?(sighting)
      sighting = Sighting.new(sighting)
      sighting.save
    end
  end
end
    p date, location, description

    # sighting = Sighting.new(date, location, description)
    # sighting.save # conn.exec("INSERT INTO sightings")
  end
  # conn.close
end

read_file(data_file) #, conn)
end


# def main
# end
#
# main if __FILE__ == $PROGRAM_NAME
