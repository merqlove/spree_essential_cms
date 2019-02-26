require "spree_essentials"
require "spree_sample" if Rails.env.test? || Rails.env.development?
require "rdiscount"

require "spree_essential_cms/version"
require "spree_essential_cms/engine"

module SpreeEssentialCms

  def self.tab
    { :label => "Pages", :route => :admin_pages }
  end

  def self.sub_tab
    [ :pages, { :label => Spree.t('admin.subnav.pages'), :match_path => '/pages' }]
  end

  class << self
    attr_accessor :route_regex, :contents, :sub_pages

    def contents
      @contents ||= false
    end
    alias :contents? :contents

    def sub_pages
      @sub_pages ||= false
    end
    alias :sub_pages? :sub_pages

    def route_regex
      @route_regex ||= ""
    end
  end
end

SpreeEssentials.register :cms, SpreeEssentialCms
