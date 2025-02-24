require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    # @letters = ["a", "e", "p", "l", "p"]
    @letters = []
    10.times do
      @letters << ("a".."z").to_a.sample
    end
  end

  def score
    @answer = params["word"]
    @valid_word = valid_word?(@answer)
    @english_word = english_word?(@answer)
    @score = 0
    @valid_word && @english_word ? @score = @answer.chars.count : @score
  end

  private

  def valid_word?(word)
    attempted_word = word.chars
    @possible_letters = params["letters"]

    attempted_word.each do |letter|
      if @possible_letters.include?(letter)
        @possible_letters.delete(letter)
      else
        return false
      end
    end

    def english_word?(word)
      response = URI.open("https://dictionary.lewagon.com/#{word}")
      json = JSON.parse(response.read)
      return json['found']
    end
  end
end
