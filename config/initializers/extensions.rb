module ActiveRecord
  class Base  
    def self.to_select(conditions = nil)
      find(:all).collect { |x| [x.name,x.id] }
    end
  end
end

class Array
  def to_select
    self.collect { |x| [x.name,x.id] }
  end
end

module ActiveSupport
	module CoreExtensions
		module Time 
			module Conversions
				DATE_FORMATS[:slash] = '%m/%d/%y'
			end
		end
	end
end

class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end
end

class Array
	def / pieces
		return [] if pieces.zero?
		piece_size = (length.to_f / pieces).ceil
		[first(piece_size), *last(length - piece_size) / (pieces - 1)]
	end
end

class String
	def url_encode
  	CGI::escape(self)
  end
  
  def url_decode
  	CGI::unescape(self)
  end
  
  def word_wrap(line_width = 80)
    self.split("\n").collect do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end
end

class NilClass
	def each; self; end
	include Enumerable
end
