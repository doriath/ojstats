require 'typhoeus'

module OnlineJudges::Spoj
  # Represents the page that is listing the problems (problem id, name, num of
  # accepts, etc.)
  class ProblemsPage
    def initialize(url)
      @url = url
    end

    # @return [Boolean]
    def has_next?
      !!next_url
    end

    # @return [String,nil]
    def next_url
      page.css('.pager_link').each do |link|
        if link.text == 'Next' or link.text == 'Dalej'
          uri = URI(@url)
          return uri.scheme + "://" + uri.host + link[:href]
        end
      end
      nil
    end

    # @return [Array<Problem>]
    def problems
      names = page.css('.problemrow td:nth-child(3) a')
      accepts = page.css('.problemrow td:nth-child(4) a')
      names.zip(accepts).map do |name, num_accepts|
        OnlineJudges::Problem.new(name.text.strip, num_accepts.text.strip.to_i)
      end
    end

    # Uses pagination to fetch all problems starting from given url.
    #
    # @return [Array<Problem>]
    def self.problems_starting_from(url)
      problems = []
      problems_page = ProblemsPage.new(url)
      loop do
        problems << problems_page.problems
        break unless problems_page.has_next?
        problems_page = ProblemsPage.new(problems_page.next_url)
      end
      problems.flatten
    end

    private

    def page
      @page ||= get_html_page(@url)
    end

    def get_html_page(url)
      Nokogiri::HTML(get_page(url))
    end

    def get_page(url)
      Typhoeus::Request.get(url).body
    end
  end
end
