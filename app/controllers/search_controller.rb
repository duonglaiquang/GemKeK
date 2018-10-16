class SearchController < ApplicationController
  def index
    puts "params"
    puts params[:search]
    @games = Game.search(params[:search])
    @genres = Genre.search(params[:search])
    @platforms = Platform.search(params[:search])

    @search_results = []
    @games.each do |game|
      @search_results.push(game)
    end

    @genres.each do |genre|
      genre.game_of_genre.each do |g|
        @search_results.push(g)
      end
    end

    @platforms.each do |platform|
      platform.game_of_platform.each do |g|
        @search_results.push(g)
      end
    end
  end

  def advance_search
    @games = params[:game_ids]
    @search_results = []

    puts "search result"
    @search_results.each do |q|
      puts q
    end
    @params_genre = params[:genre].to_i == 0 ? "" : Genre.find(params[:genre].to_i).name
    @params_platform = params[:platform].to_i == 0 ? "" : Platform.find(params[:platform].to_i).name
    @params_score = params[:score] == "" ? "" : params[:score]

    if (params[:score] != nil)
      params_score = params[:score].scan(/\d+|"-"|\d+/)
      if params_score != nil
        score_min = params_score[0]
        score_max = params_score[1]
      end
    end

    if (@games != nil)
      @games.each do |game_id|
        platform = Game.find(game_id).platform_of_game
        genre = Game.find(game_id).genres_of_game
        score = Game.find(game_id).reviews.average(:rating)


        flag1 = params[:platform].to_i == 0 ? true : false
        if (flag1 == false)
          platform.each do |p|
            if (params[:platform].to_i != 0 && p.id.to_i == params[:platform].to_i)
              flag1 = true
            end
          end
        end
        puts "flag1"
        puts flag1
        flag2 = params[:genre].to_i == 0 ? true : false
        if (flag2 == false)
          genre.each do |g|
            if (params[:genre].to_i != 0 && g.id.to_i == params[:genre].to_i)
              flag2 = true
            end
          end
        end
        puts "flag2"
        puts flag2

        flag3 = params_score.size == 0 ? true : false
        if (flag3 == false)
          if (score.to_i >= score_min.to_i && score.to_i <= score_max.to_i)
            flag3 = true
          end
        end
        puts "flag3"
        puts flag3
        if flag1 == true && flag2 == true && flag3 == true
          @search_results.push(game_id)
        end
      end

    end
  end
end