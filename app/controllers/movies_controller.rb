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
    #session.delete(:order)
    #@movies = Movie.order("title")
    #@checked_ratings = params[:ratings]#.keys #==> this works, but if null breaks the whole thing. works without keys, beacuse keys breaks on undefined
    
    @all_ratings = Movie.listof_ratings.keys
    if params[:order].present?
      session[:order] = params[:order]
    end
    if params[:ratings].present?
      session[:ratings] = params[:ratings]
    end
    @checked_ratings = Movie.with_ratings(session[:ratings])
    @movies = Movie.where(rating: @checked_ratings).order(session[:order])
   
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
    session.delete(:order)
    session.delete(:ratings)
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
