class SessionsController < ApplicationController
    def new
        render :new
    end

    def create
        user = User.find_by_credentials(params[:user][:email], params[:user][:password]) 
        session[:session_token] = user.reset_session_token!
        redirect_to users_url
    end

    def destroy
        logout!
        redirect_to new_session_url
    end





end
