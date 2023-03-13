class Product < ApplicationRecord
  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 100000 }
end
