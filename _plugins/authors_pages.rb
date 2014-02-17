require 'ostruct'


module Jekyll

  class Author
    def initialize(hash)
      @hash = hash
    end

    def method_missing(method, *args, &block)
      if @hash.include? method.to_sym
        return @hash[method.to_sym]
      end
      super
    end

    def to_liquid
      @hash
    end
  end

  class AuthorIndexPage < Page
    def initialize(site, base, dir, author)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'authors_index.html')

      self.data['author'] = author
      posts = []
      site.posts.each do |post|

        if post.data["author"] == author
          posts << post
        end
      end
      self.data["posts"] = posts
      author_title_prefix = site.config['author_title_prefix'] || 'By '
      self.data['title'] = "#{author_title_prefix}#{author}"
    end
  end

  class AuthorPage < Page
    def initialize(site, base, dir, authors)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'authors.html')
      new_authors = []
      authors.each do |author, attrs|
        vars = Hash[attrs.map{ |k, v| [k.to_sym, v] }]
        tmp = Author.new(vars)
        new_authors << tmp
      end
      self.data['authors'] = new_authors

      self.data['title'] = "Authors"
    end
  end

  class AuthorIndexPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'authors_index'
        dir = site.config['authors_dir'] || 'authors'
        authors = site.config["authors"] || []

        authors.keys.each do |author|
          site.pages << AuthorIndexPage.new(site, site.source, File.join(dir, author), author)
        end
      end
    end
  end

  class AuthorPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'authors'
        dir = site.config['authors_dir'] || 'authors'
        authors = site.config["authors"] || []

        site.pages << AuthorPage.new(site, site.source, dir, authors)
      end
    end
  end

end
