class User < ApplicationRecord
  has_many :posts
  validates :company, presence: true
end
