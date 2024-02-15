require 'rails_helper'

RSpec.describe Member, type: :model do
  before do
    @member = FactoryBot.build(:member)
  end

  describe '参加希望の保存' do
    context '参加希望が登録できる場合' do
      it '全項目入力で登録できる' do
        expect(@member).to be_valid
      end

      it '紹介文が空でも登録できる' do
        @member.content = ''
        expect(@member).to be_valid
      end
    end

    context '参加希望が登録できない場合' do
      it 'タイトルが空では登録できない' do
        @member.title = ''
        @member.valid?
        expect(@member.errors.full_messages).to include("Title can't be blank")
      end

      it '活動地域が空では登録できない' do
        @member.areas = []
        @member.valid?
        expect(@member.errors.full_messages).to include("Area ids can't be blank")
      end

      it '希望パートが空では登録できない' do
        @member.parts = []
        @member.valid?
        expect(@member.errors.full_messages).to include("Part ids can't be blank")
      end
      
      it 'ユーザーが紐付いていなければ登録できない' do
        @member.user = nil
        @member.valid?
        expect(@member.errors.full_messages).to include("User must exist")
      end
    end
  end
end
