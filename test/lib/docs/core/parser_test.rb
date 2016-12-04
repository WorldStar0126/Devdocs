require 'test_helper'
require 'docs'

class DocsParserTest < MiniTest::Spec
  def parser(content)
    Docs::Parser.new(content)
  end

  describe "#html" do
    it "returns a Nokogiri Node" do
      assert_kind_of Nokogiri::XML::Node, parser('').html
    end

    context "with an HTML fragment" do
      it "returns the fragment" do
        body = '<div>Test</div>'
        assert_equal body, parser(body).html.inner_html
      end
    end

    context "with an HTML document" do
      it "returns the <body>" do
        body = '<!doctype html><meta charset=utf-8><title></title><div>Test</div>'
        assert_equal '<div>Test</div>', parser(body).html.inner_html

        body = '<html><meta charset=utf-8><title></title><div>Test</div></html>'
        assert_equal '<div>Test</div>', parser(body).html.inner_html
      end
    end
  end

  describe "#title" do
    it "returns nil when there is no <title>" do
      body = '<!doctype html><meta charset=utf-8><div>Test</div>'
      assert_nil parser(body).title
    end

    it "returns the <title> when there is one" do
      body = '<!doctype html><meta charset=utf-8><title>Title</title><div>Test</div>'
      assert_equal 'Title', parser(body).title
    end
  end
end
