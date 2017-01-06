class Question < ActiveRecord::Base
    acts_as_votable
    acts_as_taggable
    belongs_to :user
    has_many :answers
end
