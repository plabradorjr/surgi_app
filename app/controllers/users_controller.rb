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
      redirect to '/'
    else
      redirect to '/'
    end
  end

  get '/user/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if @user
          erb :'users/show_individual_user'
      else
          erb :'/users/dontexist'
      end
    else
      redirect to '/'
    end
  end

  get '/noresult' do
    if logged_in?
      erb :'notes/no_result'
    else
      redirect to '/'
    end
  end

  get '/users' do
    @all_users = User.all

    erb :'users/show_all_users'
  end

  get '/user/:username/edit' do
     
    if logged_in? && (params[:username] == current_user.username.downcase.gsub(" ","-"))
      @user = User.find_by_id(current_user.id)
      erb :'users/edit_user'
    else
      redirect to '/prohibited'
    end
  end

  patch '/saved' do

    if logged_in?
      if params[:username] == ""
        'Username cannot be blank, press the back browser button.'
      else
        @user = User.find_by_id(current_user.id)
        @user.update(username: params[:username], bio: params[:bio])
        erb :"users/show_individual_user"
      end
    else
      redirect to '/login'
    end
  end




end 