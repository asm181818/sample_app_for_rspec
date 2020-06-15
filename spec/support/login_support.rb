module LoginSupport
  def sign_in(user)
    # ログイン画面に遷移
    visit login_path
    # 各フォームへの入力値が正常
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    # Loginボタンをクリック
    click_button 'Login'
  end
end