class Article < ApplicationRecord
  validates :body, presence: true

  def to_s
    body
  end
end
