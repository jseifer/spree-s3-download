S3Options = (YAML.load_file("#{RAILS_ROOT}/config/s3.yml")[RAILS_ENV].symbolize_keys rescue Errno::ENOENT).merge(ENV)
