class Post
  include Mongoid::Document
  field :title, type: String
  field :body, type: String
  field :starred, type: Mongoid::Boolean
end
