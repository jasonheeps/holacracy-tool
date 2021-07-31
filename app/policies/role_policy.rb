class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.admin
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    user.admin
  end

  def update?
    edit?
  end

  def destroy?
    circle = record.primary_circle
    role = Role.find_by(primary_circle: circle, role_type: :sec)
    user.employee.roles.include?(role) || user.admin
  end
end
