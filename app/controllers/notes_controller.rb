class NotesController < ApplicationController

  get '/home' do
    if logged_in?
      @notes = Note.all
      erb :'notes/home'
    else
      redirect to '/login'
    end
  end

  get '/note/new' do
    if logged_in?
      erb :'notes/create_note'
    else
      redirect to '/login'
    end
  end

  post '/notes' do
    if logged_in?
      if params[:content] == "" || params[:topics] == ""
        redirect to "/note/new"
      else
        @note = current_user.notes.build(content: params[:content], topics: params[:topics])
        if @note.save
          redirect to "/note/#{@note.id}"
        else
          redirect to "/note/new"
        end
      end
    else
      redirect to '/login'
    end
  end

  get '/note/:id' do
    if logged_in?
      @note = Note.find_by_id(params[:id])
      erb :'notes/show_note'
    else
      redirect to '/login'
    end
  end


  get '/note/:id/edit' do
    if logged_in?
      @note = Note.find_by_id(params[:id])
      if @note ## && @note.user == current_user //commented out so anyone can edit
        erb :'notes/edit_note'
      else
        redirect to '/prohibited' #temporary redirect
      end
    else
      redirect to '/login'
    end
  end


  patch '/note/:id' do
    if logged_in?
      if params[:content] == ""
        redirect to "/note/#{params[:id]}/edit"
      else
        @note = Note.find_by_id(params[:id])
        if @note ## && @note.user == current_user // commented out so anyone can edit
          if @note.update(content: params[:content], topics: params[:topics])
            redirect to "/note/#{@note.id}"
          else
            redirect to "/note/#{@note.id}/edit"
          end
        else
          redirect to '/home'
        end
      end
    else
      redirect to '/login'
    end
  end

  get '/prohibited' do
    if logged_in?
      erb :'notes/prohibited'
    else
      redirect to '/login'
    end 
  end

  delete '/note/:id/delete' do
    if logged_in?
      @note = Note.find_by_id(params[:id])
      if @note && @note.user == current_user
        @note.delete
      else 
        redirect to '/prohibited'
      end
    else
      redirect to '/login'
    end
  end

  get '/all' do
    if logged_in?
      @note = Note.all
      erb :'notes/show_all_notes'
    else
      redirect to '/login'
    end    
  end

  post '/search' do
    @query = Note.find_by(:topics => params[:searchquery])
    if @query
      redirect to 'all'
    else
      redirect to '/prohibited' ##temp redirect, just testing
    end
  end




end 