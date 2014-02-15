# place this file in your plugins directory and add the tag to your sidebar
# $ cat source/_includes/custom/asides/categories.html
#<section>
#  <h1>Categories</h1>
#  <ul id="categories">
#    {% category_list %}
#  </ul>
#</section>

module Jekyll
  class CategoryListTag < Liquid::Tag
    def render(context)
      html = ""
      colors = ["black", "red", "blue", "orange", "purple", "teal", "green"]
      categories = context.registers[:site].categories.keys
      categories.sort.each do |category|
        posts_in_category = context.registers[:site].categories[category].size
        # <a href="#" class="item"><div class="ui purple circular label">34</div> {{ cat[0] }}</a>

        html << "<a href='/categories/#{category}/' class='item'><div class='ui #{colors.sample} circular label'>#{posts_in_category}</div> #{category.capitalize}</a>\n"
      end
      html
    end
  end
end

Liquid::Template.register_tag('category_list', Jekyll::CategoryListTag)
