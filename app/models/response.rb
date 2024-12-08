class Response < ApplicationRecord
  belongs_to :form

  enum status: { pending: 0, completed: 1, failed: 2 }
end
