Feature: 管理得分
  
  Scenario: 上传得分
    Given 我是一个管理员
    When 我访问得分管理
    And 上传一个得分
    Then 我应该看到上传成功的消息
    And 用户的得分应该发生变化
