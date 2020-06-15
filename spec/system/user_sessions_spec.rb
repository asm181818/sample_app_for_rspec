require 'rails_helper'
require 'support/driver_setting'
require 'support/login_support'

RSpec.describe "UserSessions", type: :system do
  include LoginSupport
  let(:user) { FactoryBot.create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        sign_in(user)
        # ログイン成功のフラッシュメッセージが表示されるページ(task一覧ページ)に遷移
        expect(page).to have_content 'Login successful'
      end
    end
    context 'フォームが未入力' do
      it 'メールアドレスが未入力だとログイン処理が失敗する' do
        # メールアドレスが未入力
        visit login_path
        fill_in 'Email', with: ''
        fill_in 'Password', with: user.password
        click_button 'Login'
        expect(page).to have_content 'Login failed'
      end
      it 'パスワードが未入力だとログイン処理が失敗する' do
        visit login_path
        fill_in 'Email', with: user.email
        # パスワードが未入力
        fill_in 'Password', with: ''
        click_button 'Login'
        expect(page).to have_content 'Login failed'
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        sign_in(user)
        visit root_path
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
      end
    end
  end
end
