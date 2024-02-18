require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # ログインページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('Sign up')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ユーザー名', with: @user.name
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード（6文字以上）', with: @user.password
      fill_in 'パスワード再入力', with: @user.password_confirmation
      # 新規登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        click_on('新規登録')
        sleep 1
      }.to change { User.count }.by(1)
      # トップページへ遷移することを確認する
      expect(page).to have_current_path(root_path)
      # ヘッダーにマイページボタンが表示されることを確認する
      expect(page).to have_content('マイページ')
      # ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # ログインページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('Sign up')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード（6文字以上）', with: ''
      fill_in 'パスワード再入力', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        click_on('新規登録')
        sleep 1
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインに成功し、ヘッダーにマイページボタンが表示される' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # ログインページへ移動する
    visit new_user_session_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq(new_user_session_path)
    # すでに保存されているユーザーのemailとpasswordを入力する
    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: @user.password
    # ログインボタンをクリックする
    find('input[name="commit"]').click
    sleep 1
    # ヘッダーにマイページボタンが表示されることを確認する
    expect(page).to have_content('マイページ')
  end
  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # ログインページへ移動する
    visit new_user_session_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq(new_user_session_path)
    # 誤ったユーザー情報を入力する
    fill_in 'メールアドレス', with: 'test'
    fill_in 'パスワード', with: 'test'
    # ログインボタンをクリックする
    find('input[name="commit"]').click
    sleep 1
    # サインインページに戻ってきていることを確認する
    expect(current_path).to eq(new_user_session_path)
  end
end

RSpec.describe 'ユーザー編集機能', type: :system do
  context 'ユーザー編集ができるとき' do
    it 'ユーザーが編集が成功し、マイページに編集後の内容が表示される' do
      # 予め、ユーザーをDBに保存する
      @user = FactoryBot.create(:user)
      # ログインする
      sign_in(@user)
      # マイページへ移動する
      visit user_path(@user)
      # ユーザー編集ページへ移動する
      visit edit_user_path(@user)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(page).to have_field('user_name', with: @user.name)
      expect(page).to have_field('user_email', with: @user.email)
      # フォームの内容を編集する
      fill_in 'ユーザー名',with: "#{@user.name}test"
      fill_in 'メールアドレス',with: "test#{@user.email}"
      # 編集してもUserモデルのカウントは変わらないことを確認する
      expect{
        click_on('更新する')
        sleep 1
      }.to change { User.count }.by(0)
      # マイページへ移動する
      visit user_path(@user)
      # マイページに先ほど変更した内容のが存在することを確認する
      expect(page).to have_content("#{@user.name}test")
      expect(page).to have_content("test#{@user.email}")
    end
  end
  context 'ユーザー編集ができないとき' do
    it 'ユーザー編集に失敗し、再びユーザー編集ページに戻ってくる' do
      # 予め、ユーザーをDBに保存する
      @user = FactoryBot.create(:user)
      # ログインする
      sign_in(@user)
      # マイページへ移動する
      visit user_path(@user)
      # ユーザー編集ページへ移動する
      visit edit_user_path(@user)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(page).to have_field('user_name', with: @user.name)
      expect(page).to have_field('user_email', with: @user.email)
      # 誤ったフォームの内容を入力する
      fill_in 'ユーザー名',with: ''
      fill_in 'メールアドレス',with: ''
      # 更新ボタンをクリックする
      click_on('更新する')
      sleep 1
      # ユーザー編集ページに戻ってきていることを確認する
      expect(current_path).to eq(edit_user_path(@user))
    end
  end
end

RSpec.describe 'ユーザー削除機能', type: :system do
  it 'ユーザーがアカウントを削除する' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # ログインする
    sign_in(@user)
    # マイページへ移動する
    visit user_path(@user)
    # ユーザー編集ページへ移動する
    visit edit_user_path(@user)
    # アカウントを削除するとレコードの数が1減ることを確認する
    expect{
      click_on('アカウント削除')
      sleep 1
    }.to change { User.count }.by(-1)
    # トップページに遷移することを確認する
    expect(current_path).to eq(root_path)
  end
end