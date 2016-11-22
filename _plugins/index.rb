module Jekyll
  module RemoveIndexFilter
    def remove_index(input)
      url = if input
        input.split("/")[0..-2].join("/") + "/"
      else
        input
      end
      url
    end
  end
end

Liquid::Template.register_filter(Jekyll::RemoveIndexFilter)
