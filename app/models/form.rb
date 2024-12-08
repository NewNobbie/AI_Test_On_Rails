class Form < ApplicationRecord
  has_many :responses, dependent: :destroy

  validates :name, length: { maximum: 50 }
end
