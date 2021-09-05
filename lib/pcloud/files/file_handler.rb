require 'open-uri'
require 'zip'

module Pcloud
  class FileHandler

    def initialize(client)
      @client = client
    end

    def upload(params, payload)
      @client.request(:post, 'uploadfile', params, payload)
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
        stat = @client.request(:get, "stat", {fileid: params[:fileid]})
        raise NotFoundError.new(:fileid, params[:fileid]) if stat[:error]
        filename = stat[:metadata][:name]
      end
      File.write("#{destination}/#{filename}", @client.request(:get, "gettextfile", {fileid: params[:fileid], raw: true}))
    end 

    def download_folder(params)
      data = @client.request(:get, "listfolder", {folderid: params[:folderid]})
      raise NotFoundError.new(:folderid, params[:folderid]) if data[:error]

      destination = params[:destination] || '.'
      folder_name = params[:filename] || data[:metadata][:name] << ".zip"
      stringio = Zip::OutputStream::write_buffer do |zio|
        data[:metadata][:contents].each do |content|
          zio.put_next_entry(content[:name])
          zio.write(@client.request(:get, "gettextfile", {fileid: content[:fileid], raw: true}))
        end
      end
      stringio.rewind #reposition buffer pointer to the beginning
      File.new("#{destination}/#{folder_name}","wb").write(stringio.sysread) #write buffer to zipfile
    end

  end
end
