class UsersController < ApplicationController

rescue_from ActiveRecord::RecordInvalid, with: :invalid_entry
before_action :authorize, only: [:show]

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find_by(id: session[:user_id])
        # byebug
        if user.valid?
            render json: user
        else
            render json: {error: "Not authorized"}, status: :unauthorized
        end
    end


    private

    def authorize
        render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id
    end

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def invalid_entry
        render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end


end
