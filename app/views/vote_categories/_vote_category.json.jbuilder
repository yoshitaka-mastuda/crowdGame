json.extract! vote_category, :id, :vote_id, :category_id, :created_at, :updated_at
json.url vote_category_url(vote_category, format: :json)
