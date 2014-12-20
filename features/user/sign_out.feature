Feature: 登出
  为了保护用户不被未授权的访问所伤害
  一个已经登录的用户应该可以登出

  Scenario: 登出
    Given 一个已经登录的用户
    When 访问登出页面
    Then 我应该看到登出的消息
