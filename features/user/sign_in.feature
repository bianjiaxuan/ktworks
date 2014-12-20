Feature: 登录
  为了保护网站不被垃圾信息填充
  我们需要用户登录来完成操作

  Scenario: 用户没有注册
    Given 一个不存在的用户
    When 登录
    Then 我应该看到登录失败的消息
    And 我应该被转到注册页

  Scenario: 用户已经登录
    Given 一个已经登录的用户
    When 访问登录页面
    Then 我应该看到登录过的消息
    And 我应该被转到首页

  Scenario: 用户使用错误邮箱登录
    Given 一个存在的用户
    And 我没有登录
    When 我使用错误的邮箱来登录
    Then 我应该看到登录失败的消息

  Scenario: 用户使用错误密码登录
    Given 一个存在的用户
    And 我没有登录
    When 我使用错误的密码来登录
    Then 我应该看到登录失败的消息
