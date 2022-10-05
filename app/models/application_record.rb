class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to shards: {
    default: { writing: :primary, reading: :primary },
    dc: { writing: :primary_dc, reading: :primary_dc },
    marvel: { writing: :primary_marvel, reading: :primary_marvel }
  }
end
