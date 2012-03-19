FactoryGirl.define do

  factory :spree_page, :class => Spree::Page do
    title            "Just a page"
    meta_title       { self.title }
    meta_description { "Nothing too cool here except the title: #{title}." }
    meta_keywords    { "just, something, in, a, list, #{title.downcase}" }
  end

  factory :spree_content, :class => Spree::Content do
    page { Spree::Page.first }
    title "Just some content"
    body  { "Nothing too cool here except the title: #{title}." }
  end

  factory :spree_page_image, :class => Spree::PageImage do
    viewable { Spree::Page.first }
    attachment { sample_image }
  end

  sequence :user_authentication_token do |n|
    "xxxx#{Time.now.to_i}#{rand(1000)}#{n}xxxxxxxxxxxxx"
  end

  factory :user, :class => Spree::User do
    email { Faker::Internet.email }
    login { email }
    password 'secret'
    password_confirmation 'secret'
    authentication_token { FactoryGirl.generate(:user_authentication_token) } if Spree::User.attribute_method? :authentication_token
  end

  factory :admin_user, :parent => :user do
    roles { [Spree::Role.find_by_name('admin') || Factory(:role, :name => 'admin')]}
  end

  sequence(:role_sequence) { |n| "Role ##{n}" }

  factory :role, :class => Spree::Role do
    name { FactoryGirl.generate :role_sequence }
  end

  factory :admin_role, :parent => :role do
    name 'admin'
  end
end
