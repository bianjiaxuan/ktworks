Feature: 赛事视图
  要展示赛事信息

  Scenario: 公告
    Given 我没有登录
    When 我访问赛事信息
    Then 我应该看到比赛公告
    And 我应该看到选手心得
