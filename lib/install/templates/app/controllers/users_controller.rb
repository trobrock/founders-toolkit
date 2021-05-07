# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :redirect_if_set, only: %i(new create)
  skip_before_action :authenticate, only: %i(new create)

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(@user)
      redirect_to :root
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if Current.user.update(user_params)
      redirect_to [:edit, Current.user], notice: 'Successfully updated your profile.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
