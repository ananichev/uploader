require File.expand_path(File.dirname(__FILE__) + '/lib/sinatra/lib/sinatra')
require File.expand_path(File.dirname(__FILE__) + '/lib/config')
require File.expand_path(File.dirname(__FILE__) + '/lib/stored_file')
require 'ftools'

get '/' do
  @files = StoredFile.all
  haml :list
end

post '/' do
  tempfile = params['file'][:tempfile]
  filename = params['file'][:filename]
  digest = Digest::SHA1.hexdigest(filename)
  @file = StoredFile.create(filename: params['file'][:filename], sha: digest)
  FileUtils.cp(tempfile.path, "./files/#{@file.id}.upload")
  redirect '/'
end

get '/:sha' do
  @file = StoredFile.first(sha: params[:sha])
  send_file "./files/#{@file.id}.upload", filename: @file.filename, type: 'Application/octet-stream'
  redirect '/'
end

get '/:sha/delete' do
  @file = StoredFile.first(sha: params[:sha])
  File.delete("./files/#{@file.id}.upload")
  @file.destroy
  redirect '/'
end
