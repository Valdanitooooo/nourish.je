module Jekyll
  module ConcatFilter
    def concat(one, two)
      one.concat(two)
    end
    def md5(input)
      Digest::MD5.hexdigest(input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::ConcatFilter)
