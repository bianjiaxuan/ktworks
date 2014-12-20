Feature: 入场管理
  验证用户和参赛验证码
  生成参赛号码

  Scenario: 验证合法用户
    Given 我是一个管理员
    When 我访问入场管理
    And 我提交合法信息
    Then 我应该看到参赛号码

  Scenario: 验证不合法用户
    Given 我是一个管理员
    When 我访问入场管理
    And 我提交不合法信息
    Then 我应该看到错误消息
