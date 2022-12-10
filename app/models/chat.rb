class Chat < ApplicationRecord
  validates :username, presence: true
  validates :message, presence: true
end
