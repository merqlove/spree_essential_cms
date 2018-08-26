require "spree_essentials"
require "spree_sample" unless Rails.env.production?
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

end

SpreeEssentials.register :cms, SpreeEssentialCms
