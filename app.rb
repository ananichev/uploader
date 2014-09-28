require 'lib/stored_file'

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
