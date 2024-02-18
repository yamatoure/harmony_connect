module CheckboxesSupport
  def random_check(checkboxes)
    random_count = rand(1..checkboxes.count)
    checkboxes.sample(random_count).each do |checkbox|
      checkbox.check
    end
  end

  # メンバー募集投稿の活動地域選択
  def group_area_check
    area_checkboxes = all('input[name="group[area_ids][]"]')
    random_check(area_checkboxes)
  end

  # メンバー募集投稿の募集パート選択
  def group_part_check
    part_checkboxes = all('input[name="group[part_ids][]"]')
    random_check(part_checkboxes)
  end

  # 参加希望登録の活動地域選択
  def member_area_check
    area_checkboxes = all('input[name="member[area_ids][]"]')
    random_check(area_checkboxes)
  end

  # 参加希望登録の希望パート選択
  def member_part_check
    part_checkboxes = all('input[name="member[part_ids][]"]')
    random_check(part_checkboxes)
  end
end