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
      downcase_topic = params[:topics].downcase
      topic_already_made = Note.find_by(:topics => downcase_topic)
      if params[:content] == "" || params[:topics] == ""
        redirect to "/note/new"
      elsif topic_already_made
        @error_message = 'This topic has already been made. Try searching or choose a different name.'
        erb :'notes/prohibited'
      else
        @note = current_user.notes.build(content: params[:content], topics: downcase_topic)
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
      if @note
        erb :'notes/show_note'
      else
        @error_message = "Sorry, this item doesn't exist yet."
        erb :'notes/prohibited'
      end
    else
      redirect to '/login'
    end
  end


  get '/note/:id/edit' do
    if logged_in?
      @note = Note.find_by_id(params[:id])
      if @note ## && @note.user == current_user #commented out so anyone can edit
        erb :'notes/edit_note'
      else
        @error_message = "This entry was deleted by the original user."
        erb :'notes/prohibited' 
      end
    else
      redirect to '/login'
    end
  end


  patch '/note/:id' do
    if logged_in?
      downcase_topic = params[:topics].downcase
      topic_already_made = Note.find_by(:topics => downcase_topic)
      if params[:content] == ""
        redirect to "/note/#{params[:id]}/edit"
      elsif topic_already_made
        @error_message = 'This topic has already been made. Try searching or choose a different name.'
        erb :'notes/prohibited'
      else
        @note = Note.find_by_id(params[:id])
        if @note ## && @note.user == current_user // commented out so anyone can edit
          if @note.update(content: params[:content], topics: downcase_topic)
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


  delete '/note/:id/delete' do
    if logged_in?
      @note = Note.find_by_id(params[:id])
      if @note && @note.user == current_user
        @note.delete
        redirect to '/all'
      else 
        @error_message = "Sorry, only the original user can delete that form."
        erb :'notes/delete_prohibited'
      end
    else
      redirect to '/login'
    end
  end

  get '/note' do
    if logged_in?
      @note = Note.all
      erb :'notes/show_all_notes'
    else
      redirect to '/login'
    end    
  end

  post '/search' do
    x = params[:searchquery]
    # @query = Note.where("topics LIKE?", params[:searchquery]) ## this work just like the below code. keeping this for future use.
    @query = Note.all.find{|i| i.topics.downcase.gsub(" ", "-") == x.downcase.gsub(" ", "-")}
    if @query
      erb :'notes/search_results'
    else
      redirect to '/noresult' 
    end
  end




end 