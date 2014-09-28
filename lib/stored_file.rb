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
  property :sha, String
  property :downloads, Integer, default: 0
  property :filesize, Integer

  default_scope(:default).update(order: [:created_at.desc])
end

DataMapper.auto_upgrade!
