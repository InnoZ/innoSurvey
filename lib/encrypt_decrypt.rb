# derived from https://gist.github.com/wteuber/5318013
######################################################

require 'openssl'

class String
  def encrypt(key: 'FhMdavn9o7FZwTnmvJ8BCqsov89miw6b8LeikQvBjMpjEjzDitfa87zvZiraffHf')
    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = key
    s = cipher.update(self) + cipher.final
    s.unpack('H*')[0].upcase
  end

  def decrypt(key: 'FhMdavn9o7FZwTnmvJ8BCqsov89miw6b8LeikQvBjMpjEjzDitfa87zvZiraffHf')
    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
    cipher.key = key
    s = [self].pack("H*").unpack("C*").pack("c*")
    cipher.update(s) + cipher.final
  end
end
