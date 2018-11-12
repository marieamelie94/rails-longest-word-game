require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letter_grid = []
    @alphabet = ('A'..'Z').to_a
    10.times { @letter_grid << @alphabet.sample }
    session[:grid] = @letter_grid
  end

  def score
    @word = params[:word]
    @grid = session[:grid]
    run_game(@word, @grid)
  end
  # is the world english / valid ?

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    check_english = open(url).read
    english = JSON.parse(check_english)
    english['found']
  end
  # match with grid given ?

  def in_the_grid?(word, grid)
    attempt_array = word.upcase.split('')
    attempt_array.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
  end

  def run_game(word, grid)
    @results = {}
    if english?(word) == false
    @results = { score: 0, message: 'The given word is not an english word' }
    # does the word match with the grid?
    elsif in_the_grid?(word, grid) == false
      @results = { score: 0, message: 'The given word is not in the grid' }
    else
    @results = { score: word.length * 2, message: 'Well done' }
      # TODO: runs the game and return detailed hash of result
    end
  end
end
