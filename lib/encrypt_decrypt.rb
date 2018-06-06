# derived from https://gist.github.com/wteuber/5318013
######################################################

require 'openssl'

class String
  def encrypt(key: 'ratzEncryptTheInnoZ')
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = cipher.update(self) + cipher.final
    s.unpack('H*')[0].upcase
  end

  def decrypt(key: 'ratzEncryptTheInnoZ')
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').decrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = [self].pack("H*").unpack("C*").pack("c*")
    cipher.update(s) + cipher.final
  end
end
