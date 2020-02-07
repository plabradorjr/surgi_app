class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to '/home'
    end
  end

  post '/signup' do
    username_taken = User.find_by(:username => params[:username])
    email_taken = User.find_by(:email => params[:email])
    if username_taken
        redirect to '/nametaken'
    elsif email_taken
        redirect to '/emailtaken'
    elsif params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/home'
    end
  end


  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to '/home'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/home"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end
  

end 