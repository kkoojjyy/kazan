require 'spec_helper'

RSpec.describe 'Project with configuration' do
  before(:all) do
    setup_app_dependencies
    run_app_generator
  end

  after(:all) do
    drop_app_database
  end

  BINSTUBS = [
    'rake',
    'rails',
    'rspec'
  ]

  SETTINGS = [
    'Gemfile',
    'README.md',
    '.ruby-version',
    '.gitignore',
    '.env.development',
    '.env.production',
  ]

  CONFIGS = [
    'database.yml',
    'database.yml.example',
    'puma.rb'
  ]

  INITIALIZERS = [
    'bullet.rb'
  ]

  GEMS = [
    'annotate',
    'awesome_print',
    'better_errors',
    'bullet',
    'dotenv',
    'letter_opener',
    'pg',
    'pry-byebug',
    'pry-rails',
    'puma',
    'rack-mini-profiler',
    'rails'
  ]

  describe 'spring bin' do
    subject { File }

    it { is_expected.to exist("#{project_path}/bin/spring") }
  end

  BINSTUBS.each do |bin_stub|
    describe bin_stub do
      subject { IO.read("#{project_path}/bin/#{bin_stub}") }

      it { is_expected.to match(/spring/) }
    end
  end

  SETTINGS.each do |config|
    describe config do
      subject { load_file config }

      it { is_expected.to be_truthy}
    end
  end

  CONFIGS.each do |config|
    describe config do
      subject { load_file "config/#{config}" }

      it { is_expected.to be_truthy }
    end
  end

  INITIALIZERS.each do |initializer|
   describe initializer do
     subject { load_file "config/initializers/#{initializer}" }

     it { is_expected.to be_truthy }
   end
  end

  # describe 'simple_from.rb' do
    # subject { load_file 'config/initializers/simple_form.rb' }

     # it { is_expected.to be_truthy }
   # end

  describe 'Gemfile' do
    subject { load_file 'Gemfile' }

    GEMS.each do |gem|
      it { is_expected.to include gem }
    end
  end

  describe 'application.rb' do
    subject { load_file 'config/application.rb' }

    it { is_expected.to match(/action_on_unpermitted_parameters = :raise/) }
    it { is_expected.to match(/config.generators/) }
    it { is_expected.to match(/config.assets.quiet = true/) }
  end

  describe 'environments/development.rb' do
    subject { load_file 'config/environments/development.rb' }

    it { is_expected.to be_truthy }
    it { is_expected.to match(/raise_delivery_errors = true/) }
    it { is_expected.to match(/action_mailer.default_url_options/) }
    it { is_expected.to match(/action_mailer.delivery_method/) }
    it { is_expected.to match(/raise_on_missing_translations = true/) }
  end

  describe 'environments/test.rb' do
    subject { load_file 'config/environments/test.rb' }

    it { is_expected.to be_truthy }
    it { is_expected.to match(/config.assets.raise_runtime_errors = true/) }
    it { is_expected.to match(/raise_on_missing_translations = true/) }
  end

  describe 'environments/staging.rb' do
  end

  describe 'environments/production.rb' do
    subject { load_file 'config/environments/production.rb' }

    it { is_expected.to be_truthy }
  end
end
