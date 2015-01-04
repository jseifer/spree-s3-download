require 'aws/s3'
class S3Product < ActiveRecord::Base
  belongs_to :product
  validates_presence_of :product
  attr_accessor :temporary_url

  def filename
    @filename ||= s3_url.scan(/http[s]{0,1}:\/\/.*?\/(.*?)$/).flatten.first
  end

  def extension
    @extension ||= filename.split('.').last
  end
end