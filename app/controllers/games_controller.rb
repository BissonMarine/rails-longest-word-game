require 'open-uri'

class GamesController < ApplicationController
  def new
    # Code à exécuter
    @letters = generate_grid(10)
  end

  def score
    # Code à exécuter
    @game = params[:answer]
    # On veut maîtriser trois scénarios :
    # mot ne peut pas être créé à partir de la grille d’origine,
    @letters = params[:sorted_letters]
    @in_grid = word_in_grid?(@game, @letters)
    # mot est valide d’après la grille, mais ce n’est pas un mot anglais valide.
    @valid = valid_word?(@game)
    # mot est valide d’après la grille et est un mot anglais valide.
    # raise
    if @in_grid == true && @valid == true
      @score = @game.length
    else
      'Bad answer, try again !'
      @score = 0
    end
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid_size.times do
      grid << ('A'..'Z').to_a.sample
    end
    grid
  end

  # Définir méthode valid_word pour vérifier que mot = dans liste + mot anglais correct
  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized_words = URI.parse(url).read
    word_hash = JSON.parse(serialized_words)
    word_hash['found']
  end

  def word_in_grid?(attempt, grid)
    attempt_array = attempt.upcase.split("")
    grid_array = grid.split(" ")
    # attempt_array.include?(grid_array)
    attempt_array.all? { |attempt_letter| grid_array.include?(attempt_letter) }
    # raise
  end
end
