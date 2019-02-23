class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  @all_ratings = Movie.distinct.pluck(:rating)
  
  if !params[:order].nil?
   session[:order] = params[:order] 
  end
  
  if session[:order] == "title"
    @switch_title = "hilite"
  end
  
  if session[:order] == "release_date"
    @switch_date = "hilite" 
    
  end
  
  if !params[:ratings].nil?
    session[:ratings] = params[:ratings]
    @ratings = session[:ratings]
    else
      if !params[:ratings].nil?
        @ratings = @all_ratings
        elsif session[:ratings]
          flash.keep
          redirect_to movies_path(order: session[:order], ratings: session[:ratings])
      else
        @ratings = @all_ratings
      end
  end
 
  @movies = Movie.order(session[:order]).where(:rating => @ratings)
  @selected_ratings = (params[:ratings].present? ? params[:ratings] : [])
   
    
    
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end