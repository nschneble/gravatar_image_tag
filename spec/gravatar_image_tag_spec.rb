require File.dirname(__FILE__) + '/test_helper'

require 'gravatar_image_tag'

RSpec.describe GravatarImageTag do
  let(:email) { 'mdeering@mdeering.com' }
  let(:md5) { '4da9ad2bd4a2d1ce3c428e32c423588a' }
  let(:default_filetype) { :gif }
  let(:default_image) { 'http://mdeering.com/images/default_gravatar.png' }
  let(:default_image_escaped) { 'http%3A%2F%2Fmdeering.com%2Fimages%2Fdefault_gravatar.png' }
  let(:default_rating) { 'x' }
  let(:default_size) { 50 }
  let(:other_image) { 'http://mdeering.com/images/other_gravatar.png' }
  let(:other_image_escaped) { 'http%3A%2F%2Fmdeering.com%2Fimages%2Fother_gravatar.png' }
  let(:secure) { false }

  let(:view) do
    ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
  end

  around do |example|
    original_config = GravatarImageTag.configuration
    GravatarImageTag.configuration = GravatarImageTag::Configuration.new
    example.run
  ensure
    GravatarImageTag.configuration = original_config
  end

  before do
    ActionView::Base.send(:include, GravatarImageTag)
    GravatarImageTag.configure do |c|
      c.default_image = default_image
      c.filetype = default_filetype
      c.rating = default_rating
      c.size = default_size
      c.secure = secure
      c.include_size_attributes = true
    end
  end

  context '#gravatar_image_tag' do

    let(:tag_cases) do
      [
        { params: { gravatar_id: md5 }, options: {} },
        { params: { gravatar_id: md5 }, options: { gravatar: { rating: 'x' } } },
        { params: { gravatar_id: md5, size: 30 }, options: { gravatar: { size: 30 } } },
        { params: { gravatar_id: md5, default: other_image_escaped }, options: { gravatar: { default: other_image } } },
        { params: { gravatar_id: md5, default: other_image_escaped, size: 30 }, options: { gravatar: { default: other_image, size: 30 } } }
      ]
    end

    it 'creates the provided url with the provided options' do
      tag_cases.each do |test_case|
        params = test_case.fetch(:params).dup
        options = test_case.fetch(:options)
        image_tag = view.gravatar_image_tag(email, options)

        expect(image_tag).to include(params.delete(:gravatar_id).to_s)
        params.each do |key, value|
          expect(image_tag).to include("#{key}=#{value}")
        end
      end
    end

    let(:deprecation_cases) do
      {
        default_gravatar_image: default_image,
        default_gravatar_filetype: default_filetype,
        default_gravatar_rating: default_rating,
        default_gravatar_size: default_size,
        secure_gravatar: secure
      }
    end

    it 'warns when assigning deprecated configuration methods and sets new values' do
      deprecation_cases.each do |singleton_variable, value|
        expect(ActionView::Base).to receive(:warn)
        ActionView::Base.send("#{singleton_variable}=", value)

        case singleton_variable
        when :default_gravatar_image
          expect(GravatarImageTag.configuration.default_image).to eq(value)
        when :default_gravatar_filetype
          expect(GravatarImageTag.configuration.filetype).to eq(value)
        when :default_gravatar_rating
          expect(GravatarImageTag.configuration.rating).to eq(value)
        when :default_gravatar_size
          expect(GravatarImageTag.configuration.size).to eq(value)
        when :secure_gravatar
          expect(GravatarImageTag.configuration.secure).to eq(value)
        end
      end
    end

    let(:defaults_set_cases) do
      [
        { params: { gravatar_id: md5, size: default_size, default: default_image_escaped }, options: {} },
        { params: { gravatar_id: md5, size: 30, default: default_image_escaped }, options: { gravatar: { size: 30 } } },
        { params: { gravatar_id: md5, size: default_size, default: other_image_escaped }, options: { gravatar: { default: other_image } } },
        { params: { gravatar_id: md5, size: 30, default: other_image_escaped }, options: { gravatar: { default: other_image, size: 30 } } }
      ]
    end

    it 'creates the provided url when defaults have been set with the provided options' do
      defaults_set_cases.each do |test_case|
        params = test_case.fetch(:params).dup
        options = test_case.fetch(:options)
        image_tag = view.gravatar_image_tag(email, options)

        expect(image_tag).to include("#{params.delete(:gravatar_id)}.#{default_filetype}")
        params.each do |key, value|
          expect(image_tag).to include("#{key}=#{value}")
        end
      end
    end

    it 'requests the gravatar image from the non-secure server when the https: false option is given' do
      image_tag = view.gravatar_image_tag(email, gravatar: { secure: false })
      expect(image_tag).not_to match(%r{^https://secure\.gravatar\.com/avatar/})
    end

    it 'requests the gravatar image from the secure server when the https: true option is given' do
      image_tag = view.gravatar_image_tag(email, gravatar: { secure: true })
      expect(image_tag).to match(%r{src="https://secure\.gravatar\.com/avatar/})
    end

    it 'sets the image tags height and width to avoid layout shifts when loading many Gravatars' do
      GravatarImageTag.configure { |c| c.size = 30 }
      image_tag = view.gravatar_image_tag(email)
      expect(image_tag).to match(/height="30"/)
      expect(image_tag).to match(/width="30"/)
    end

    it 'sets the image tags height and width attributes to 80px (gravatar default) if no size is given' do
      GravatarImageTag.configure { |c| c.size = nil }
      image_tag = view.gravatar_image_tag(email)
      expect(image_tag).to match(/height="80"/)
      expect(image_tag).to match(/width="80"/)
    end

    it 'sets the image tags height and width attributes from size overrides' do
      GravatarImageTag.configure { |c| c.size = 120 }
      expect(view.gravatar_image_tag(email, gravatar: { size: 45 })).to match(/height="45"/)
      expect(view.gravatar_image_tag(email, gravatar: { size: 75 })).to match(/width="75"/)
    end

    it 'does not include height and width attributes when disabled in configuration' do
      GravatarImageTag.configure { |c| c.include_size_attributes = false }
      image_tag = view.gravatar_image_tag(email)
      expect(image_tag).not_to match(/height=/)
      expect(image_tag).not_to match(/width=/)
    end

    it 'does not error when email is nil for gravatar_id' do
      expect { GravatarImageTag.send(:gravatar_id, nil) }.not_to raise_error
    end

    it 'normalizes the email to Gravatar standards (http://en.gravatar.com/site/implement/hash/)' do
      expect(view.gravatar_image_tag(" camelCaseEmail@example.com\t\n")).to eq(view.gravatar_image_tag('camelcaseemail@example.com'))
    end

  end

  context '#gravatar_image_url' do

    it 'returns a gravatar URL' do
      expect(view.gravatar_image_url(email)).to match(%r{^http://gravatar\.com/avatar/})
    end

    it 'sets the email as an md5 digest' do
      expect(view.gravatar_image_url(email)).to match(%r{http://gravatar\.com/avatar/#{md5}})
    end

    it 'sets the default_image' do
      expect(view.gravatar_image_url(email)).to include("default=#{default_image_escaped}")
    end

    it 'sets the filetype' do
      expect(view.gravatar_image_url(email, filetype: :png)).to match(%r{http://gravatar\.com/avatar/#{md5}\.png})
    end

    it 'sets the rating' do
      expect(view.gravatar_image_url(email, rating: 'pg')).to include('rating=pg')
    end

    it 'sets the size' do
      expect(view.gravatar_image_url(email, size: 100)).to match(/size=100/)
    end

    it 'uses http protocol when the https: false option is given' do
      expect(view.gravatar_image_url(email, secure: false)).to match(%r{^http://gravatar\.com/avatar/})
    end

    it 'uses https protocol when the https: true option is given' do
      expect(view.gravatar_image_url(email, secure: true)).to match(%r{^https://secure\.gravatar\.com/avatar/})
    end

  end

end
