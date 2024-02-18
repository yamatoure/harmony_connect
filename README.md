# テーブル設計

## users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| name               | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |

### Association

- has_many   :groups
- belongs_to :member

## groups テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| title   | string     | null: false                    |
| content | text       |                                |
| user    | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_many   :group_areas
- has_many   :areas, through: :group_areas
- has_many   :group_parts
- has_many   :parts, through: :group_parts

## members テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| title   | string     | null: false                    |
| content | text       |                                |
| user    | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_many   :member_areas
- has_many   :areas, through: :member_areas
- has_many   :member_parts
- has_many   :parts, through: :member_parts

## areas　テーブル

| Column  | Type       | Options     |
| ------- | ---------- | ------------|
| area    | string     | null: false |

### Association

- has_many :group_areas
- has_many :groups, through: :group_areas
- has_many :member_areas
- has_many :members, through: :member_areas

## parts テーブル

| Column  | Type       | Options     |
| ------- | ---------- | ----------- |
| part    | string     | null: false |

### Association

- has_many :group_parts
- has_many :groups, through: :group_parts
- has_many :member_parts
- has_many :members, through: :member_parts

## group_areas テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| group   | references | null: false, foreign_key: true |
| area    | references | null: false, foreign_key: true |

### Association

- belongs_to :group
- belongs_to :area

## member_areas テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| member  | references | null: false, foreign_key: true |
| area    | references | null: false, foreign_key: true |

### Association

- belongs_to :member
- belongs_to :area

## group_parts テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| group   | references | null: false, foreign_key: true |
| part    | references | null: false, foreign_key: true |

### Association

- belongs_to :group
- belongs_to :part

## member_parts テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| member  | references | null: false, foreign_key: true |
| part    | references | null: false, foreign_key: true |

### Association

- belongs_to :member
- belongs_to :part