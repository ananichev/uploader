require File.expand_path(File.dirname(__FILE__) + '/lib/sinatra/lib/sinatra')
require File.expand_path(File.dirname(__FILE__) + '/config/config')
require File.expand_path(File.dirname(__FILE__) + '/lib/stored_file')
require 'ftools'

get '/' do
  @files = StoredFile.all
  haml :list
end

get '/style.css' do
  response['Content-Type'] = 'text/css; charset=utf-8'
  sass :style
end

post '/' do
  tempfile = params['file'][:tempfile]
  filename = params['file'][:filename]
  digest = Digest::SHA1.hexdigest(filename)
  @file = StoredFile.create(filename: params['file'][:filename], sha: digest, filesize: File.size(tempfile.path))
  FileUtils.cp(tempfile.path, "./files/#{@file.id}.upload")
  redirect '/'
end

get '/:sha/:id' do
  @file = StoredFile.first(sha: params[:sha], id: params[:id])
  unless params[:nowait] == 'true'
    haml :download
  else
    @file.downloads += 1
    @file.save
    send_file "./files/#{@file.id}.upload", filename: @file.filename, type: 'Application/octet-stream'
  end
end

get '/:sha/:id/delete' do
  @file = StoredFile.first(sha: params[:sha], id: params[:id])
  File.delete("./files/#{@file.id}.upload")
  @file.destroy
  redirect '/'
end
