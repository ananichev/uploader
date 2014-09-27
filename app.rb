require 'sinatra'
require 'dm-core'
require 'dv-validations'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/mydatabase.sqlite3")

class StoredFile
  include DataMapper::Resource

  property :id, Integer, serial: true
  property :filename, String, nullable: false
  property :created_at, DateTime

  default_scope(:default).update(order: [:created_at.desc])
end


get '/' do

end

post '/' do

end

get '/:id' do

end

get '/:id/delete' do

end
