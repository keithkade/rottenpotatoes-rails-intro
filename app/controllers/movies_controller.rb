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

    #for generating the checkboxes
    @all_ratings = Movie.ratingsArr

    new_params = {}
    redirect_needed = false

    #use session to remember selections
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    #default to all checked
    if (!session.has_key?('ratings'))
      @selected = Movie.ratingsHash
      eligible_movies = Movie.all
      session[:ratings] = @selected
    else
      @selected = session[:ratings]
      eligible_movies = Movie.where(:rating => @selected.keys)
    end

    if session[:sort_by]
      @sort_by = session[:sort_by]
      @movies = eligible_movies.order(@sort_by + ' ASC')
    else
      @movies = eligible_movies
    end

    #keep it restful. if sort_by or ratings is not in our params construct new ones and redirect
    if !params[:sort_by] && session[:sort_by]
      redirect_needed = true
      new_params[:sort_by] = session[:sort_by]
    else
      new_params[:sort_by] = params[:sort_by]
    end

    if !params[:ratings]
      redirect_needed = true
      new_params[:ratings] = session[:ratings]
    else
      new_params[:ratings] = params[:ratings]
    end

    if redirect_needed
      redirect_to movies_path(new_params)
    end

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
