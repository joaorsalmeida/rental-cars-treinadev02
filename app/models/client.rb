class Client < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :document, presence: true


  def description
    "#{name} - #{document}"
  end
end
