# -*- encoding : iso-8859-1 -*-
=begin
:-----------------------------------------------------------------------------:
: 查詢內碼程式 v0.6                    by  Witch - Five (s793016), 10/27/2013 :
:-----------------------------------------------------------------------------:
=end

def help_exit
 puts 
 puts "Useage: "+File.basename("#{$0}")+" [b|u] [word|內碼]".force_encoding("Big5")
 puts "=" * 40
 puts <<SEC1
b = big5
u = unicode

SEC1
 puts "word = 單一中文字 - 限 Big5".force_encoding("Big5")
 puts "內碼 = 4位數字，如：A140".force_encoding("Big5")
 exit
end

def read2byte(fnls,seekw)
 cw = IO.binread(fnls,2,seekw).unpack('H*').join().upcase # array \xab,\xcd 變 ab,cd 變 abcd 轉大寫
 cw[2, 2]+cw[0, 2] #用 LE 記述，所以要反過來讀
end

# 取參數
s1, s2 = ARGV
nls = "C_950.NLS"
fpath = ".\\"

if not File.exist?(fpath+nls)
 fpath = ENV['windir']+"\\system32\\"
 if not File.exist?(fpath+nls)
  puts "\n"+File.basename("#{$0}")+" 找不到 #{nls} ，不能運作查尋。".force_encoding("Big5")
  exit
 end 
end

if s1 == nil or s2 == nil # 沒參數
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
  # 字串轉byte陣列，char 2 ascii-dec
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

# 輸出結果
print "\n關於「".force_encoding("Big5"),cdef,"-".force_encoding("Big5")
print [uc].pack('H*').force_encoding("UTF-16BE") # 字串 ABCD 當 array 變 \xAB\xCD 直接出 UTF16
print "」：\n".force_encoding("Big5")
puts
print "Big-5 內碼為「".force_encoding("Big5"),b5,"」，\n".force_encoding("Big5")
print "Unicode 碼為「".force_encoding("Big5"),uc,"」。\n".force_encoding("Big5")
puts "\nPS: "
puts "  1.若以上其中一碼為 003F，則此字在另一字集中並無對應!!".force_encoding("Big5")
puts "  2.若顯示為「unicode-  」，則表示您使用的字型中缺此字".force_encoding("Big5")
puts
