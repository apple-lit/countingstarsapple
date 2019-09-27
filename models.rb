require 'bundler/setup'
Bundler.require
if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class Count < ActiveRecord::Base
  has_many :users
end

class User < ActiveRecord::Base
has_secure_password
validates :name,
presence: true,
format: { with: /\A[a-zA-Z0-9]+\z/ }
validates :password,
length: {in: 5..10}
end

class UserCount < ActiveRecord::Base
  belongs_to :user
  belongs_to :count
end