Feature: 管理比赛
  为了能够管理比赛
  管理员应该可以新建、修改、删除比赛

  Scenario: 新建比赛
    Given 我是一个管理员
    When 我访问比赛管理
    And 提交新的比赛
    Then 我应该看到新的比赛

  Scenario: 修改比赛
    Given 我是一个管理员

  Scenario: 删除比赛
    Given 我是一个管理员

