class RoleFilling < ApplicationRecord
  belongs_to :employee
  belongs_to :role
  has_many :shifts, dependent: :destroy

  enum role_filling_status: {
    ccm: 0,
    non_ccm: 1,
    substitute: 2
  }
end
