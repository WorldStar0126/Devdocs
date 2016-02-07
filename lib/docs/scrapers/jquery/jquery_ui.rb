module Docs
  class JqueryUi < Jquery
    self.name = 'jQuery UI'
    self.slug = 'jqueryui'
    self.release = '1.11.4'
    self.base_url = 'https://api.jqueryui.com'
    self.root_path = '/category/all'

    html_filters.insert_before 'jquery/clean_html', 'jquery_ui/entries'

    options[:root_title] = 'jQuery UI'
    options[:skip] = %w(/theming)
    options[:skip_patterns] += [/\A\/1\./]

    options[:fix_urls] = ->(url) do
      url.sub! 'http://api.jqueryui.com/', 'https://api.jqueryui.com/'
    end
  end
end
