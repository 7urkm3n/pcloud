require 'open-uri'
require 'zip'

module Pcloud
  class FileHandler

    def initialize(client)
      @client = client
    end

    def upload(params, payload)
      request(:post, 'uploadfile', params, payload)
    end

    def download(params)
      # destination = params[:destination] ? params[:destination] : '.'
      # data = request(:get, "getfilelink", {fileid: params[:fileid], forcedownload: 1})
      # url = "https://#{data[:hosts][0]+data[:path]}"
      # IO.copy_stream(URI.open(url), "#{destination}/#{url.split("/").last}")
      # File.write("#{destination}/#{url.split("/").last}", URI.open(url).read)

      destination = params[:destination] || '.'
      filename = params[:filename] || nil
      if !filename
        stat = request(:get, "stat", {fileid: params[:fileid]})
        filename = stat[:metadata][:name]
      end
      File.write("#{destination}/#{filename}", request(:get, "gettextfile", {fileid: params[:fileid], raw: true}))
    end

    def download_folder(params)
      data = request(:get, "listfolder", {folderid: params[:folderid]})
      destination = params[:destination] || '.'
      folder_name = params[:filename] || data[:metadata][:name] << ".zip"
      stringio = Zip::OutputStream::write_buffer do |zio|
        data[:metadata][:contents].each do |content|
          zio.put_next_entry(content[:name])
          zio.write(request(:get, "gettextfile", {fileid: content[:fileid], raw: true}))
        end
      end
      stringio.rewind #reposition buffer pointer to the beginning
      File.new("#{destination}/#{folder_name}","wb").write(stringio.sysread) #write buffer to zipfile
    end

    private

    def request(verb, path, params, payload = {})
      Pcloud::Request.call(@client, verb, path, params, payload)
    end
  end
end
