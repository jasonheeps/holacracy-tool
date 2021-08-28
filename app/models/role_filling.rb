class RoleFilling < ApplicationRecord
  belongs_to :employee
  belongs_to :role
  has_many :shifts, dependent: :destroy

  # the rails plural of 'stauts' is 'statuses'
  enum status: {
    ccm: 0,
    non_ccm: 1,
    substitute: 2
  }

  def self.enum_to_s(enum_key)
    case enum_key
    when 'ccm'
      'CCM'
    when 'non_ccm'
      'Nicht-CCM'
    when 'substitute'
      'Vertretung'
    else
      'Error: enum symbol is invalid'
    end
  end
end
