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
    # 'record' is a RoleFilling
    circle = Role.find_by_id(record.role).primary_circle
    sec = circle.secretary_role
    user.employee.roles.include?(sec) || user.admin
  end
end
