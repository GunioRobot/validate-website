require File.expand_path('../spec_helper', __FILE__)

describe ValidateWebsite::Core do

  before do
    FakeWeb.clean_registry
    @validate_website = ValidateWebsite::Core.new(:color => false)
  end

  describe('html') do
    it "extract url" do
      name = 'xhtml1-strict'
      file = File.join('spec', 'data', "#{name}.html")
      page = FakePage.new(name,
                          :body => open(file).read,
                          :content_type => 'text/html')
      @validate_website.site = page.url
      @validate_website.crawl(:quiet => true)
      @validate_website.anemone.pages.size.must_equal 5
    end
  end

  describe('css') do
    it "crawl css and extract url" do
      page = FakePage.new('test.css',
                          :body => ".test {background-image: url(pouet);}
                                    .tests {background-image: url(/image/pouet.png)}
                                    .tests {background-image: url(/image/pouet_42.png)}
                                    .tests {background-image: url(/image/pouet)}",
                                    :content_type => 'text/css')
      @validate_website.site = page.url
      @validate_website.crawl(:quiet => true)
      @validate_website.anemone.pages.size.must_equal 5
    end

    it "should extract url with single quote" do
      page = FakePage.new('test.css',
                          :body => ".test {background-image: url('pouet');}",
                          :content_type => 'text/css')
      @validate_website.site = page.url
      @validate_website.crawl(:quiet => true)
      @validate_website.anemone.pages.size.must_equal 2
    end

    it "should extract url with double quote" do
      page = FakePage.new('test.css',
                          :body => ".test {background-image: url(\"pouet\");}",
                          :content_type => 'text/css')
      @validate_website.site = page.url
      @validate_website.crawl(:quiet => true)
      @validate_website.anemone.pages.size.must_equal 2
    end
  end
end
