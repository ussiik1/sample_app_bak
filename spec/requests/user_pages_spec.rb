require 'spec_helper'

describe "UserPages" do
  subject { page }
  describe "profile page" do
    # Code to make a user variable
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
  describe "signup page" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should have_selector('li', text: "Email can't be blank") }
        it { should have_selector('li', text: "Email is invalid") }
        it { should have_selector('li', text: "Name can't be blank") }
        #it { should have_selector('li', text: "Name is too long (maximum is 50 characters)") }
        it { should have_selector('li', text: "Password can't be blank") }
        it { should have_selector('li', text: "Password is too short (minimum is 6 characters)") }
        it { should have_selector('li', text: "Password confirmation can't be blank") }
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
      end
      describe "after submission with fill in Name with 50 over words" do
        before do
          fill_in "Name",         with: "1234567891123456789212345678931234567894123456789512345"
          click_button submit
        end
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should have_selector('li', text: "Email can't be blank") }
        it { should have_selector('li', text: "Email is invalid") }
        #it { should have_selector('li', text: "Name can't be blank") }
        it { should have_selector('li', text: "Name is too long (maximum is 50 characters)") }
        it { should have_selector('li', text: "Password can't be blank") }
        it { should have_selector('li', text: "Password is too short (minimum is 6 characters)") }
        it { should have_selector('li', text: "Password confirmation can't be blank") }
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end
