class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :body, presence: true

  def to_s
    body
  end
end
