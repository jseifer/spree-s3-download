begin
  options = YAML.load_file("#{RAILS_ROOT}/config/s3.yml")[RAILS_ENV]
rescue Errno::ENOENT
  options = ENV
ensure
  S3Options = options.symbolize_keys
end