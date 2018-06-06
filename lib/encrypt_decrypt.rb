# derived from https://gist.github.com/wteuber/5318013
######################################################

require 'openssl'

class String
  def encrypt(key: 'ratzEncryptTheInnoZ')
    cipher = OpenSSL::Cipher.new('AES-256-CBC').encrypt
    cipher.key = "\x9D5\xD8\x85\x9B\xE0\xC2S\x8D\x82D\x99\xDB=\x8C\xAA\x18z\x15LV\xE4Q\xE6\x88\x8D\x16\x89\xA9gf\xAE"
    s = cipher.update(self) + cipher.final
    s.unpack('H*')[0].upcase
  end

  def decrypt(key: 'ratzEncryptTheInnoZ')
    cipher = OpenSSL::Cipher.new('AES-256-CBC').decrypt
    cipher.key = "\x9D5\xD8\x85\x9B\xE0\xC2S\x8D\x82D\x99\xDB=\x8C\xAA\x18z\x15LV\xE4Q\xE6\x88\x8D\x16\x89\xA9gf\xAE"
    s = [self].pack("H*").unpack("C*").pack("c*")
    cipher.update(s) + cipher.final
  end
end
