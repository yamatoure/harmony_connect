module SignInSupport
  def sign_in(user)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
    expect(page).to have_current_path(root_path)
  end
end