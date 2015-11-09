require "logger"
require "pry"
require "capybara"
require 'capybara/poltergeist'
require "faker"
require "active_support"
require "active_support/core_ext"

module LoadScript
  class Session
    include Capybara::DSL
    attr_reader :host
    def initialize(host = nil)
      Capybara.default_driver = :poltergeist
      @host = host || "http://localhost:3000"
    end

    def logger
      @logger ||= Logger.new("./log/requests.log")
    end

    def session
      @session ||= Capybara::Session.new(:poltergeist)
    end

    def run
      while true
        run_action(actions.sample)
      end
    end

    def run_action(name)
      benchmarked(name) do
        send(name)
      end
    rescue Capybara::Poltergeist::TimeoutError
      logger.error("Timed out executing Action: #{name}. Will continue.")
    end

    def benchmarked(name)
      logger.info "Running action #{name}"
      start = Time.now
      val = yield
      logger.info "Completed #{name} in #{Time.now - start} seconds"
      val
    end

    def log_in(email="demo+horace@jumpstartlab.com", pw="password")
      log_out
      session.visit host
      session.click_link("Login")
      session.fill_in("session_email", with: email)
      session.fill_in("session_password", with: pw)
      session.click_link_or_button("Log In")
    end

    def log_out
      session.visit host
      if session.has_content?("Log out")
        session.find("#logout").click
      end
    end

    def new_user_name
      "#{Faker::Name.name} #{Time.now.to_i}"
    end

    def new_user_email(name)
      "TuringPivotBots+#{name.split.join}@gmail.com"
    end

    def categories
      ["Agriculture", "Education", "Community"]
    end

    def actions
      [
        :anonymous_user_browses_loan_requests,
        :user_browses_pages_of_loan_requests,
        :user_browses_categories,
        :user_browses_pages_of_categories,
        :user_views_individual_loan_request,
        :new_user_signs_up_as_lender,
        :new_user_signs_up_as_borrower,
        :new_borrower_creates_loan_request
      ]
    end

    # Endpoints

    def anonymous_user_browses_loan_requests
      log_out
      session.visit "#{host}/browse"
      session.all(".lr-about").sample.click
    end

    def user_browses_pages_of_loan_requests
      log_in
      session.visit "#{host}/browse"
    end

    def user_browses_categories
      log_in
      session.visit "#{host}/categories"
      session.all("p a").sample.click
    end

    def user_browses_pages_of_categories
      log_in
      session.visit "#{host}/categories"
      session.all("p a").sample.click # select a category
      session.all(".lr-about").sample.click # select a loan request
    end

    def user_views_individual_loan_request
      log_in
      session.visit "#{host}/browse"
      session.all(".lr-about").sample.click
    end

    def new_user_signs_up_as_lender(name = new_user_name)
      log_out
      session.find("#sign-up-dropdown").click
      session.find("#sign-up-as-lender").click
      session.within("#lenderSignUpModal") do
        session.fill_in("user_name", with: name)
        session.fill_in("user_email", with: new_user_email(name))
        session.fill_in("user_password", with: "password")
        session.fill_in("user_password_confirmation", with: "password")
        session.click_link_or_button "Create Account"
      end
    end

    def new_user_signs_up_as_borrower(name = new_user_name)
      log_out
      session.find("#sign-up-dropdown").click
      session.find("#sign-up-as-borrower").click
      session.within("#borrowerSignUpModal") do
        session.fill_in("user_name", with: name)
        session.fill_in("user_email", with: new_user_email(name))
        session.fill_in("user_password", with: "password")
        session.fill_in("user_password_confirmation", with: "password")
        session.click_link_or_button "Create Account"
      end
    end

    def new_borrower_creates_loan_request
      new_user_signs_up_as_borrower
      session.click_link_or_button("Create Loan Request")
      session.within("#loanRequestModal") do
        session.fill_in("Title", with: "Some New Loan Request")
        session.fill_in("Description", with: "Descriptiony words.")
        session.fill_in("Image url", with: "http://www.kiva.org/img/w800/1854916.jpg")
        session.fill_in("Requested by date", with: "12/15/2015")
        session.fill_in("Repayment begin date", with: "03/15/2016")
        session.select("Monthly", from: "Repayment rate")
        session.select(categories.sample, from: "Category")
        session.fill_in("Amount", with: "500")
      end
    end

  end
end
