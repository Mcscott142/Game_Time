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

def team_win_losses
teams = []
games = import_file('scores.csv')
games.each do |game|
  teams << game[:home_team]
  teams << game[:away_team]
end

teams = teams.uniq
team_name = {}
teams.each do |team|
  team_name[team] = [wins: 0, losses: 0]
end
team_name

games.each do |game|
  if game[:home_score].to_i > game[:away_score].to_i
    team_name.each do |k, v|
      if game[:home_team] == k
        v[0][:wins] += 1
      end

      if game[:away_team] == k
        v[0][:losses] += 1
      end
    end
  else
    game[:away_score].to_i > game[:home_score].to_i
    team_name.each do |k, v|
      if game[:away_team] == k
      v[0][:wins] += 1
      end

      if game[:home_team] == k
      v[0][:losses] += 1
      end
  end
end
end
team_name
end

def sort_teams
  teams = team_win_losses
  teams_loss = teams.sort_by { |k, v| v[0][:wins] && v[0][:losses] }

end

get '/leaderboard' do
@teams = sort_teams

erb :index

end

get '/leaderboard/:team_page' do
  @games = import_file('scores.csv')
  @teams = team_win_losses

@teams.each do |k, v|
  k == params[:team_page]
end
#binding.pry
  erb :show
end

