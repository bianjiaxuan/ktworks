Feature: 我的气场

  Scenario: 个人页面
    Given 一个已经登录的用户
    When 我访问我的气场
    Then 我应该看到我的积分排名
    And 我应该看到我的个人资料
