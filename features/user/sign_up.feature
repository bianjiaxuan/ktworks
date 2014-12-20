Feature: 注册
  为了防止网站被恶意使用
  我们需要用户在使用前注册

  Background:
    Given 我没有登录

  Scenario: 用户使用合法的信息注册
    When 我提交合法的数据注册
    | 昵称    | 邮箱                | 密码         | 确认密码     |
    | Ranmocy | ranmocy@world.admin | ranmocyadmin | ranmocyadmin |
    Then 我应该看到注册成功的消息

  Scenario: 用户使用不合法的邮箱注册
    When 我没有提交邮箱注册
    Then 我应该看到邮箱缺失的消息
    When 我提交不合法的数据注册
    | 昵称    | 邮箱                | 密码         | 确认密码     |
    | Ranmocy | ranmocy.world.admin | ranmocyadmin | ranmocyadmin |
    Then 我应该看到邮箱不合法的消息

  Scenario: 用户使用不合法的密码注册
    When 我没有提交密码注册
    Then 我应该看到密码缺失的消息
    When 我提交密码和确认密码不匹配注册
    Then 我应该看到密码不匹配的消息
    When 我提交不合法的数据注册
    | 昵称    | 邮箱                | 密码 | 确认密码     |
    | Ranmocy | ranmocy@world.admin | 中文 | 中文     |
    Then 我应该看到密码过短的消息
