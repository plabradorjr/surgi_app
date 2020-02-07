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

  post '/pages' do
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


end 