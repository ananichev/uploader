require 'sinatra'
require 'ftools'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/mydatabase.sqlite3")

class StoredFile
  include DataMapper::Resource

  property :id, Serial
  property :filename, String
  property :created_at, DateTime

  default_scope(:default).update(order: [:created_at.desc])
end

DataMapper.auto_upgrade!

get '/' do
  @files = StoredFile.all
  erb :list
end

post '/' do
  tempfile = params['file'][:tempfile]
  @file = StoredFile.new(filename: params['file'][:filename])
  @file.save!
  FileUtils.cp(tempfile.path, "./files/#{@file.id}.upload")
  redirect '/'
end

get '/:id' do
  @file = StoredFile.get(params[:id])
  send_file "./files/#{@file.id}.upload", filename: @file.filename, type: 'Application/octet-stream'
  redirect '/'
end

get '/:id/delete' do
  File.delete("./files/#{params[:id]}.upload")
  StoredFile.get(params[:id]).destroy
  redirect '/'
end





