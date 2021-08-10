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
    # TODO: find out why record#role is undefined and fix this...
    # circle = Role.find_by_id(record.role).primary_circle
    # sec = Role.find_by(primary_circle_id: circle.id, role_type: :sec)
    # user.employee.roles.include?(sec) || user.admin
    true
  end
end
