module VCloud
  Dir[File.expand_path('../admin/*.rb', __FILE__)].each do |file|
    require file
  end
end
