class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def create
    Rails.logger.info("User params: #{params.inspect}")
    @user = User.new(user_params)
    
    # All users get all capabilities by default
    @user.make_creator
    @user.make_backer
    
    Rails.logger.info("Created user object: #{@user.inspect}")
    
    if @user.save
      Rails.logger.info("User saved successfully")
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Account created successfully!'
    else
      Rails.logger.error("User creation failed: #{@user.errors.full_messages}")
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("Error creating user: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    @user = User.new
    flash.now[:alert] = "An error occurred while creating your account. Please try again."
    render :new, status: :unprocessable_entity
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'Account updated successfully!'
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def ensure_correct_user
    unless @user == current_user
      flash[:alert] = "You don't have permission to access this page."
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
