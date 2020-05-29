# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

require_relative 'about_dice_project'
require_relative 'about_scoring_project'

# Game class contains information about current game and players.
# Also starts the game.
class Game
  TARGET_SCORE = 3000

  def initialize(players_count = 3)
    @winner = nil
    @players = players_count.times.map { |id| Player.new(id + 1) }
  end

  # start the new game
  def start
    puts "Game starts fo #{@players.count} players\n---"

    dice_throwing(nil)

    @winner = player_with_max_score(@players)
    puts "Player #{@winner.id} won with score #{@winner.total_score}!"
    print_scores

    @winner
  end

  private

  # all players make turns sequentially until the limit(score) is reached
  def dice_throwing(winner_candidate)
    i = 0
    round = 1
    @players.cycle do |player|
      break if player == winner_candidate

      if i == @players.count
        i = 0
        round += 1
      end

      player.make_turn { puts "[info] Player's #{player.id} turn" }
      if player.total_score >= TARGET_SCORE && winner_candidate.nil?
        puts 'Start the final round'
        winner_candidate = player
      end

      i += 1
    end
  end

  def player_with_max_score(players)
    players.max_by(&:total_score)
  end

  def print_scores
    puts '---' * 15
    puts "| Player ID\t\t| Total score"
    puts '---' * 15
    @players.each do |x|
      puts "| #{x.id}\t\t\t| #{x.total_score}"
    end
    puts '---' * 15
  end
end

# Player class contains information about player (id, round and total scores).
# Also responsible for making the move (rolls).
class Player
  attr_reader :id, :total_score, :round_score

  def initialize(id)
    @id = id
    @total_score = 0
    @dice_set = DiceSet.new
  end

  def make_turn(&_block)
    yield if block_given?

    roll = nil
    round_score = 0

    result = loop do
      roll_score, roll = step_forward(roll)
      round_score += roll_score
      log_turn(roll, roll_score, round_score, @total_score)

      roll = remove_scoring_dices(roll)
      break [:zero_score, roll_score] if roll_score.zero?
      break [:bonus_roll, round_score] if roll.empty?
      break [:player_stop, round_score] unless roll_again?
    end

    process_result(result)
  end

  private

  def roll_again?
    print('Roll again? (y/n): ')
    gets.chomp == 'y'
  end

  # remove triples, '1' and '5' dicies
  def remove_scoring_dices(roll)
    (1..6).each do |x|
      3.times { roll.delete_at(roll.index(x)) } if roll.count(x) == 3
    end

    roll.delete(1)
    roll.delete(5)
    roll
  end

  # make the roll
  def step_forward(roll)
    roll = roll.nil? ? @dice_set.roll(5) : @dice_set.roll(roll.length)

    [score(roll), roll]
  end

  # calculate player's total score according on its result
  # possible symbols in `result` param:
  #   * :zero_score - roll score is 0
  #   * :player_stop - player decide to stop rolling
  #   * :bonus_roll - all dices are scoring
  #
  # @param {Array<:symbol, number>} result
  # @return {Void}
  def process_result(result)
    @total_score +=
      case result[0]
      when :player_stop
        result[1]
      when :bonus_roll
        roll = @dice_set.roll(5)
        puts '[info] Bonus roll'
        log_turn(roll, score(roll), result[1] + score(roll), result[1] + score(roll) + @total_score)
        result[1] + score(roll)
      else
        puts 'Zero score. All points in this round are reset'
        0
      end
  end

  # print info about the given params
  def log_turn(roll, roll_score, round_score, total)
    puts "Roll: #{roll}, roll score: #{roll_score}, round score: #{round_score}, total: #{total}"
  end
end

# TODO: tests for Player and Game classes

# NOTE: the game interacts with the user through the console.
# The player should decide to continue or not

# game = Game.new(2)
# game.start
