class RoleFilling < ApplicationRecord
  belongs_to :employee
  belongs_to :role
  has_many :shifts, dependent: :destroy

  validates :role_filling_status, inclusion: { in: %w(ccm non_ccm substitute) } 

  # the rails plural of 'stauts' is 'statuses'
  enum role_filling_status: {
    ccm: 0,
    non_ccm: 1,
    substitute: 2
  }

  # TODO: Understand: why am I checking strings here instead of symbols
  def humanize_status
    case role_filling_status
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
  
  def self.humanize_status(status)
    case status
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
