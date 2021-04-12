class RoleFilling < ApplicationRecord
  belongs_to :employee
  belongs_to :role
  has_many :shifts, dependent: :destroy
end
