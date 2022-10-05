class Post < ApplicationRecord
  has_many :comments # counter cache
  belongs_to :user, touch: true

  def self.very_expensive_method
    # Rails.cache.instance_variable_get(:@data)
    Rails.cache.fetch([find(ids.min), :exp]) do
      sleep(3)
      'sleeped time = 3 years'
    end
  end

  def self.touch_first
    find(ids.min).touch
  end
end
