class Product < ApplicationRecord
  has_one_attached :image
  validates :title, presence: true, uniqueness: { scope: :id }, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 100_000 }

  belongs_to :category
end
