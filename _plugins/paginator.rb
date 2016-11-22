module Jekyll
  module Paginate
    DEFAULT = {
      'collection'   => 'posts',
      'per_page'     => 5,
      'limit'        => 5,
      'permalink'    => '/page/:num/',
      'title_suffix' => ' - page :num',
      'sub_title'    => 'Page :num',
      'page_num'     => 1,
      'reversed'     => true
    }

    class PaginationPage < Page
      def initialize(site, base, dir, category)
      end
    end

    class PaginationGenerator < Generator
      def generate(site)
        for page in site.pages
          if page.data.key?('paginate') and not page.data['paginate'].key?('generated')
            site.pages.concat(paginated_pages(page))
          end
        end
      end

      def paginated_pages(page)
        defaults = DEFAULT.merge(page.site.config['pagination'] || {})

        if page.data['paginate'].is_a? Hash
          page.data['paginate'] = defaults.merge(page.data['paginate'])
        else
          page.data['paginate'] = defaults
        end

        if tag = page.data['paginate']['tag']
          page.data['paginate']['tags'] = Array(tag)
        end

        if category = page.data['paginate']['category']
          page.data['paginate']['categories'] = Array(category)
        end


        collection = if page['paginate']['collection'] == 'posts'
          page['paginate']['collection_name'] = 'posts'
          page.site.posts.docs.reverse
        else
          if page['paginate']['collection'].kind_of? String
            page['paginate']['collection_name'] = page['paginate']['collection']
            page.site.collections[page['paginate']['collection']].docs
          else
            page['paginate']['collection_name'] = 'posts'
            c = []
            for type in page['paginate']['collection']
              docs = if type == 'posts'
                       page.site.posts.docs.reverse
                     else 
                       page.site.collections[type].docs
                     end
              c.concat(docs)
            end
            c.sort! { |a,b| a.date <=> b.date }
          end
        end

        if page['paginate']['reversed'] == true
          collection = collection.reverse
        end

        if categories = page.data['paginate']['categories']
          collection = collection.reject{|p| (p.categories & categories).empty?}
        end

        if tags = page.data['paginate']['tags']
          collection = collection.reject{|p| (p.tags & tags).empty?}
        end

        config = page.data['paginate']

        pages = (collection.size.to_f / config['per_page']).ceil - 1

        if config['limit']
          pages = [pages, config['limit'] - 1].min
        end

        page.data['paginate']['pages'] = pages + 1
        page.data[page['paginate']['collection_name']] = page_items(page, collection)

        new_pages = []

        pages.times do |i|
          index = i+2

          new_page = Page.new(page.site, page.site.source, File.dirname(page.path), File.basename(page.path))
          new_page.data.merge!(page_data(page, index))

          new_page.process('index.html')

          new_pages << new_page
        end

        if next_page = new_pages[0]
          page.data['next'] = { 'title' => next_page.data['title'], 'url' => next_page.url }
        end

        new_pages.each_with_index do |p, index|
          p.data[p['paginate']['collection_name']] = page_items(p, collection)

          if index > 0
            prev_page = new_pages[index - 1]
          else 
            prev_page = page
          end

          p.data['previous'] = { 'title' => prev_page.data['title'], 'url' => prev_page.url }

          if next_page = new_pages[index + 1]
            p.data['next'] = { 'title' => next_page.data['title'], 'url' => next_page.url }
          end
        end

        new_pages
      end

      def page_data(page, index)
	{
          'description' => page.data['paginate']['sub_title'].sub(/:num/, index.to_s),
	  'paginate'  => paginate_data(page, index),
	  'permalink' => page_permalink(page, index),
	  'title'     => page_title(page, index),
	}
      end

      def page_permalink(page, index)
	subdir = page.data['paginate']['permalink'].clone.sub(':num', index.to_s)
	File.join(page.dir, subdir)
      end

      def paginate_data(page, index)
	paginate_data = page.data['paginate'].clone
	paginate_data['page_num'] = index
        paginate_data['generated'] = true
	paginate_data
      end

      def page_title(page, index)
	title = if page.data['title']
	  page.data['title']
	else
	  page.data['paginate']['collection_name'].capitalize
	end

	title += page.data['paginate']['title_suffix'].sub(/:num/, index.to_s)

	title
      end

      def page_items(page, collection)
        config = page['paginate']

        n = (config['page_num'] - 1) * config['per_page']
        max = n + (config['per_page'] - 1)

        collection[n..max]
      end
    end
  end
end
