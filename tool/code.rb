# -*- encoding : iso-8859-1 -*-
=begin
:-----------------------------------------------------------------------------:
: �d�ߤ��X�{�� v0.6                    by  Witch - Five (s793016), 10/27/2013 :
:-----------------------------------------------------------------------------:
=end

def help_exit
 puts 
 puts "Useage: "+File.basename("#{$0}")+" [b|u] [word|���X]".force_encoding("Big5")
 puts "=" * 40
 puts <<SEC1
b = big5
u = unicode

SEC1
 puts "word = ��@����r - �� Big5".force_encoding("Big5")
 puts "���X = 4��Ʀr�A�p�GA140".force_encoding("Big5")
 exit
end

def read2byte(fnls,seekw)
 cw = IO.binread(fnls,2,seekw).unpack('H*').join().upcase # array \xab,\xcd �� ab,cd �� abcd ��j�g
 cw[2, 2]+cw[0, 2] #�� LE �O�z�A�ҥH�n�ϹL��Ū
end

# ���Ѽ�
s1, s2 = ARGV
nls = "C_950.NLS"
fpath = ".\\"

if not File.exist?(fpath+nls)
 fpath = ENV['windir']+"\\system32\\"
 if not File.exist?(fpath+nls)
  puts "\n"+File.basename("#{$0}")+" �䤣�� #{nls} �A����B�@�d�M�C".force_encoding("Big5")
  exit
 end 
end

if s1 == nil or s2 == nil # �S�Ѽ�
 help_exit()
end

case s1.upcase
when "B"
 cdef="big5"
when "U"
 cdef="unicode" 
else
 help_exit()
end

case s2.bytes.count
when 2
 if cdef == "unicode"
  help_exit()
 else
  # �r����byte�}�C�Achar 2 ascii-dec
  wa=s2.bytes.to_a 
 end
when 4
 wa = Array.new
 wa[0]=s2[0, 2].hex # hex 2 dec
 wa[1]=s2[2, 2].hex
else
 help_exit()
end

case cdef
when "big5"
 b5="%02X" % wa[0]+"%02X" % wa[1]
 wseek=1184+(wa[0]-129)*512+(wa[1]-64)*2
 uc = read2byte(fpath+nls,wseek) 
when "unicode"
 uc="%02X" % wa[0]+"%02X" % wa[1]
 wseek=65570+uc.hex*2
 b5 = read2byte(fpath+nls,wseek)
end

# ��X���G
print "\n����u".force_encoding("Big5"),cdef,"-".force_encoding("Big5")
print [uc].pack('H*').force_encoding("UTF-16BE") # �r�� ABCD �� array �� \xAB\xCD �����X UTF16
print "�v�G\n".force_encoding("Big5")
puts
print "Big-5 ���X���u".force_encoding("Big5"),b5,"�v�A\n".force_encoding("Big5")
print "Unicode �X���u".force_encoding("Big5"),uc,"�v�C\n".force_encoding("Big5")
puts "\nPS: "
puts "  1.�Y�H�W�䤤�@�X�� 003F�A�h���r�b�t�@�r�����õL����!!".force_encoding("Big5")
puts "  2.�Y��ܬ��uunicode-  �v�A�h��ܱz�ϥΪ��r�����ʦ��r".force_encoding("Big5")
puts
