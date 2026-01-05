# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]

  def index
    authorize User
    @users = policy_scope(User).order(created_at: :desc)

    render inertia: "Users/Index", props: {
      users: @users.map { |user| user_json(user) }
    }
  end

  def show
    authorize @user

    render inertia: "Users/Show", props: {
      user: user_json(@user, detailed: true)
    }
  end

  def new
    @user = User.new
    authorize @user

    render inertia: "Users/New", props: {
      roles: available_roles
    }
  end

  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(12) if @user.password.blank?
    authorize @user

    if @user.save
      assign_roles(@user)
      redirect_to users_path, notice: "User was successfully created."
    else
      render inertia: "Users/New", props: {
        user: user_json(@user),
        roles: available_roles,
        errors: @user.errors.to_hash
      }
    end
  end

  def edit
    authorize @user

    render inertia: "Users/Edit", props: {
      user: user_json(@user, detailed: true),
      roles: available_roles
    }
  end

  def update
    authorize @user

    if @user.update(user_params)
      assign_roles(@user)
      redirect_to users_path, notice: "User was successfully updated."
    else
      render inertia: "Users/Edit", props: {
        user: user_json(@user, detailed: true),
        roles: available_roles,
        errors: @user.errors.to_hash
      }
    end
  end

  def destroy
    authorize @user
    @user.destroy

    redirect_to users_path, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def user_json(user, detailed: false)
    data = {
      id: user.id,
      name: user.name,
      email: user.email,
      avatar_url: user.avatar_url,
      created_at: user.created_at.iso8601,
      roles: user.roles.pluck(:name)
    }

    if detailed
      data.merge!(
        provider: user.provider,
        updated_at: user.updated_at.iso8601
      )
    end

    data
  end

  def available_roles
    %w[admin user]
  end

  def assign_roles(user)
    return unless params[:user][:roles].present?

    requested_roles = params[:user][:roles].reject(&:blank?)

    # Remove roles not in the list
    user.roles.each do |role|
      user.remove_role(role.name) unless requested_roles.include?(role.name)
    end

    # Add new roles
    requested_roles.each do |role_name|
      user.add_role(role_name) unless user.has_role?(role_name)
    end
  end
end
