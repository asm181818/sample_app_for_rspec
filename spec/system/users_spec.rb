require 'rails_helper'
require 'support/driver_setting'
require 'support/login_support'

RSpec.describe "Users", type: :system do
  include LoginSupport
  let(:user) { FactoryBot.create(:user) }
  # テストの対象
  describe 'ログイン前' do
    # テストの対象
    describe 'ユーザー新規登録' do
      # 特定の条件
      context 'フォームの入力値が正常' do
        # 確認したいアウトプット
        it 'ユーザー新規登録が成功する' do
          # ユーザー新規登録画面に遷移したとき
          visit sign_up_path
          # 各フォームへの入力値が正常
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          # SignUpボタンをクリック
          click_button 'SignUp'
          # 成功のフラッシュメッセージが表示されるページ(ログインページ)に遷移
          expect(page).to have_content 'User was successfully created.'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザー新規作成が失敗する' do
          visit sign_up_path
          # メールアドレスが未入力
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          # メールアドレス未入力のエラーメッセージが表示されるページ(新規登録ページ)に遷移
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          # 既に存在しているメールアドレス(letで作られているデータ)を入力
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          # メールアドレスが既に存在しているエラーメッセージが表示されるページ(新規登録ページ)に遷移
          expect(page).to have_content "Email has already been taken"
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          # ログインしていないときにマイページへアクセス
          visit users_path
          # ログインを要求される
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          sign_in(user)
          # ログインした状態でユーザー編集画面に遷移
          visit edit_user_path(user)
          # ユーザー情報を更新
          fill_in 'user[email]', with: 'update@example.com'
          fill_in 'user[password]', with: 'update_password'
          fill_in 'user[password_confirmation]', with: 'update_password'
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          sign_in(user)
          visit edit_user_path(user)
          # メールアドレスが未入力
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'Update'
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          sign_in(user)
          visit edit_user_path(user)
          # 別のユーザーを作成
          other_user = FactoryBot.create(:user)
          # 登録済みのメールアドレスを入力
          fill_in 'user[email]', with: other_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'Update'
          expect(page).to have_content 'Email has already been taken'
        end
      end

      context '他ユーザーのユーザー編集ページにアクセス' do
        it '他ユーザーのユーザー編集ページへのアクセスが失敗する' do
          sign_in(user)
          other_user = FactoryBot.create(:user)
          # 別のユーザーの編集ページに遷移
          visit edit_user_path(other_user)
          # 遷移が拒否される
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end
  end

  describe 'マイページ' do
    context 'タスクを作成' do
      it '新規作成したタスクが表示される' do
        sign_in(user)
        task = FactoryBot.create(:task, user: user)
        visit user_path(user)
        expect(page).to have_content 'Task list'
        expect(page).to have_content 'New task'
        expect(page).to have_content 'Mypage'
        expect(page).to have_content 'Logout'
        expect(page).to have_content 'Edit'
        expect(page).to have_content 'Back'
      end
    end
  end
end
