class RoleFillingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    sec_or_admin? 
  end

  private

  def sec_or_admin?
    circle = Role.find_by_id(record.role.id).primary_circle
    sec = Role.find_by(primary_circle_id: circle.id, role_type: :sec)
    user.employee.roles.include?(sec) || user.admin
  end
end
