class Comment < ApplicationRecord
  belongs_to :article

  validates :body, presence: true

  def to_s
    body
  end
end
