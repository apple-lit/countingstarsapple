require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'
enable :sessions


helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end


get '/' do

@counts = Count.all.order('id desc')

  erb :index
end


get '/search' do

end

get '/signin' do
  erb :sign_in

end

get '/signup' do
  erb :sign_up
end

post '/signin' do
user = User.find_by(name: params[:name])
if user && user.authenticate(params[:password])
  session[:user] = user.id
end
redirect '/'
end

post '/signup' do
  @user = User.create(name:params[:name], password:params[:password], password_confirmation:params[:password_confirmation])
  if @user.persisted?
    session[:user] = @user.id
  end
  redirect '/'
end

get '/signout' do
session[:user] = nil
redirect '/'
end

get '/counts/:id/add' do

count = Count.first
count.number = count.number + 1
count.save
redirect '/'

end

get '/counts_detail/:id/add' do

  count = Count.first
  count.number = count.number + 1
  count.save
  redirect '/counts_detail/:id/add'

end

get '/counts/:id' do

end

get '/new' do

erb :newcount

end

post '/new' do
  current_user.counts.create(name params[:title])

  redirect '/'

end

get '/user/:id' do

end