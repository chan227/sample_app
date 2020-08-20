class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(create edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info_mail"
      redirect_to root_path
    else
      flash.now[:danger] = t ".fail_create"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, "can't be empty"
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".success_update"
      redirect_to @user
    else
      flash[:danger] = t ".fail_create"
      render :edit
    end
  end

  private

  def user_params
    params.require :user.permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".fail_mess_create"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".fail_expired"
    redirect_to new_password_reset_path
  end
end
