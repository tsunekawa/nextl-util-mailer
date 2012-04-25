# -*- coding:utf-8 -*-

# ja: GitHub API経由で enju_leaf リポジトリの情報を取得するモジュール
module NextL::EnjuRepo
  REPO_API_URL = "https://api.github.com/repos/nabeta/enju_leaf"

  def self.issues
    parse(REPO_API_URL+"/events/issues")
  end

  def self.parse(url)
    JSON.parse(open(url).read)
  end
end
