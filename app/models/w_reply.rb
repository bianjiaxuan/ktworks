class WReply < ActiveRecord::Base
  validates :keyword,:reply_type,:reply_content, :presence => true

  enum_attr :reply_type, :in => [
    ['text',  0, '文本'],
    ['material',  1, '单图文'],
    ['multiple_material',2, '多图文'],
    ['audio_meterial',3, '音频']
  ]
end
