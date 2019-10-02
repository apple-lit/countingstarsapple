require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'
require 'pry'
enable :sessions


before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
end

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
img_url = ''


  if params[:file]
    img = params[:file]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  end

  @user = User.create(name:params[:name], password:params[:password], password_confirmation:params[:password_confirmation], image: img_url)
  if @user.persisted?
    session[:user] = @user.id
  end
  redirect '/'
end

get '/signout' do
session[:user] = nil
redirect '/'
end

post '/count/:id/add' do
  puts "hoge"
puts params[:id]
count = Count.find(params[:id])
# @count = Count.find(count.id).number
unless count.nil?
  count.number = count.number + 1
  count.save
  UserCount.create(user_id: current_user.id, count_id: params[:id])
end

redirect '/'

end

post '/count_detail/:id/add' do

  count = Count.find(params[:id])
  unless count.nil?
  count.number = count.number + 1
  count.save
  UserCount.create(user_id: current_user.id, count_id: params[:id])
  end
  redirect '/count/' + params[:id]

end


get '/count/:id' do
@count_detail = Count.find_by(id: params[:id])
@count_users = UserCount.where(user_id: params[:user_id])
erb :count_detail
end

get '/new' do

erb :newcount

end

post '/new' do

  img_url = ''
  if params[:file]
    img = params[:file]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  end
Count.create(name: params[:title], user_id: current_user.id, image: img_url)

  redirect '/'

end

get '/user/:id' do


end

get '/userpage' do

  @counts = Count.all.order('id desc')
  @count_users = UserCount.where(user_id: params[:user_id])
  erb :userpage
end