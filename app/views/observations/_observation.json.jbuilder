json.extract! observation, :id, :descricao, :content, :created_at, :updated_at
json.url observation_url(observation, format: :json)
