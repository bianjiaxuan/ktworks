Feature: 修改个人资料
  作为一个可以注册的网站
  用户应该可以维护他们的个人资料

  Scenario: 修改昵称
    Given 一个已经登录的用户
    When 我访问修改个人资料
    And 提交修改昵称
    Then 我应该看到我的新昵称

  Scenario: 修改邮箱
    Given 一个已经登录的用户
    

  Scenario: 修改密码
    Given 一个已经登录的用户
    

  Scenario: 修改头像
    Given 一个已经登录的用户
    

  Scenario: 修改手机号
    Given 一个已经登录的用户

  Scenario: 验证手机
    Given 一个已经登录的用户
    When 我访问验证手机
    And 我填入验证码
    Then 我应该可以看到验证成功的消息
    
  Scenario: 解除绑定
    Given 一个已经登录的用户
    And 我已经验证手机
    When 我访问验证手机页面
    Then 我应该看到手机已经验证的消息
    When 我提交解除绑定
    Then 我应该可以看到手机已经解除绑定的消息
