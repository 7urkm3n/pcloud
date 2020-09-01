class Upload 
  def self.call(auth, params)
    puts "AUTH: #{auth}"
    puts "PARAMS: #{params}"
    pr = {params: {
      folderid: 7025720177,
      filename: "test.txt",
      upload: {
        file: File.open("/Users/7urkm3n/Downloads/gurdov.com.txt")
      },
      auth: auth
    }}
    return JSON.parse(RestClient.get("#{Pcloud::BASE_URL}/uploadfile", pr))
    # fl = File.new("/Users/7urkm3n/Downloads/gurdov.com.txt", 'rb')
    # File.open(Rails.root.join('app','assets', 'images', file.original_filename filename), 'wb') do |file|
    #   file.write(source_file.read)
    # end
  end  
end
