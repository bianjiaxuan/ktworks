object false

node(:total_pages) { @articles.num_pages }
node(:total_entries) { @articles.total_count }
node(:current_page) { @articles.current_page }
node(:first_page) { @articles.first_page? }
node(:last_page) { @articles.last_page? }
node(:host) {@host}

child @articles do |game|
  attributes :id, :title,:avatar,:summary, :created_at
end
