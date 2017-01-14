class TagsController < ApplicationController
  before_action :search_init

  def index
    @tags = tag_list()
  end

  def tag_list
    @tags = ActsAsTaggableOn::Tag.all()
    @list = {}

    @tags.each do |tag|
      @list[tag] = tag.taggings_count
    end

    return @list.sort {|a1 ,a2| a2[1]<=>a1[1]}
  end

  private

  def search_init
    @search = Question.search(params[:q])
  end

end

