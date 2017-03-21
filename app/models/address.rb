class Address < ActiveRecord::Base
  validates :building, :street, :city, :country, :postal_code, presence: true

  belongs_to :appointment
end
