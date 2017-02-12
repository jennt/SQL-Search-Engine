require 'sightings'
require 'pg'

Sighting.create_table

Sighting.load_file(data_file)
