require "singleton"

def maybe_proc_reader(*symbols)
  symbols.each { |sym|
    class_eval %{
        def #{sym}
          @#{sym}.respond_to?('call') ? @#{sym}.call() : @#{sym}
        end
      }
  }
end

def maybe_proc_accessor(*symbols)
  maybe_proc_reader *symbols
  attr_writer *symbols
end

module S3DirectUpload
  class Config
    include Singleton

    NORMAL_ATTRIBUTES = [:bucket, :prefix_to_clean, :region, :url]
    MAYBE_PROC_ATTRIBUTES = [:access_key_id, :secret_access_key, :session_token]

    attr_accessor *NORMAL_ATTRIBUTES
    maybe_proc_accessor *MAYBE_PROC_ATTRIBUTES
  end

  def self.config
    if block_given?
      yield Config.instance
    end
    Config.instance
  end
end
