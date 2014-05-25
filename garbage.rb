require 'sinatra'
#require 'sinatra/reloader'
require 'csv'
require 'pry'


def import_file(csv)
  games = []
  CSV.foreach(csv, headers: true , header_converters: :symbol) do |game|
    games << game
  end
  games
end


get '/leaderboard' do
@games = import_file('scores.csv')
@winning_teams = []
@losing_teams = []
@games.each do |game|
  if game[:home_score].to_i > game[:away_score].to_i
     @winning_teams << game[:home_team]
     @losing_teams << game[:away_team]
  else
     @winning_teams << game[:away_team]
     @losing_teams << game[:home_team]
  end
@win_counts = Hash.new(0)
@winning_teams.each do |team|
  @win_counts[team] +=1
end

@loss_counts = Hash.new(0)
@losing_teams.each do |team|
  @loss_counts[team] +=1
end
@win_counts
@loss_counts
end

@teams = []
@games.each do |game|
  if !@teams.include?(game[:home_team])
    @teams << game[:home_team]
  end
  if !@teams.include?(game[:away_team])
    @teams << game[:away_team]
  end
end
binding.pry


erb :index
end
