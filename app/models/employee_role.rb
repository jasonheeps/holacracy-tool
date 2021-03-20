class EmployeeRole < ApplicationRecord
  belongs_to :employee
  belongs_to :role
end
