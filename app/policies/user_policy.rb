# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || record == user
  end

  def create?
    admin?
  end

  def update?
    admin? || record == user
  end

  def destroy?
    admin? && record != user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.has_role?(:admin)
        scope.all
      else
        scope.where(id: user&.id)
      end
    end
  end
end
