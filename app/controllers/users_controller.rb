class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :user_data_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :user_data_not_found

    def create
        new_user = User.create!(user_params)
        session[:user_id] ||= new_user.id
        render json: new_user, status: :created
    end

    def show
        render json: User.find(session[:user_id]), status: :ok
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :user)
    end

    def user_data_invalid(error_hash)
        render json: { errors: error_hash.record.errors.full_messages }, status: :unprocessable_entity
    end

    def user_data_not_found
        render json: { error: "Please login to view your account page." }, status: :not_found
    end
end
