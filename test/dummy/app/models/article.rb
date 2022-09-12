class Article < ApplicationRecord
  has_many :comments

  validates :body, presence: true
end
