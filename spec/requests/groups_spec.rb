require 'rails_helper'
describe GroupsController, type: :request do

  before do
    @group = FactoryBot.create(:group)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get groups_path
      expect(response.status).to eq 200
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みのタイトルが存在する' do 
      get groups_path
      expect(response.body).to include(@group.title)
    end

    it 'indexアクションにリクエストするとレスポンスに投稿検索チェックボックスが存在する' do 
      get groups_path
      expect(response.body).to include('検索する')
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get group_path(@group)
      expect(response.status).to eq 200
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みのタイトルが存在する' do 
      get group_path(@group)
      expect(response.body).to include(@group.title)
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みの内容が存在する' do 
      get group_path(@group)
      expect(response.body).to include(@group.content)
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みの活動地域が存在する' do 
      get group_path(@group)
      #@group.areasの配列から:areaだけの配列にして、文字列として取り出している
      expected_text = @group.areas.order(:area_id).map(&:area).join
      #response.bodyの空白をなくし、areaの文字列が一致するようにしている
      expect(response.body.gsub(/\s/,"")).to include(expected_text)
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みの募集パートが存在する' do 
      get group_path(@group)
      expected_text = @group.parts.order(:part_id).map(&:part).join
      expect(response.body.gsub(/\s/,"")).to include(expected_text)
    end

    it 'showアクションにリクエストするとレスポンスに投稿者名が存在する' do 
      get group_path(@group)
      expect(response.body).to include(@group.user.name)
    end
  end
end
