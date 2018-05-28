# -*- coding: utf-8 -*-
#phpファイルを生成するRubyの実行。
#実行時に第1引数に年度、第2引数にa or b(前期or後期)を与える(例:ruby allmake.rb 2014 a)
#puts("ipアドレスを取ってるので少々時間がかかります")

if ARGV.size != 2
  puts("usage:ruby allmake.rb [年度] [a or b(前期or後期)]");
  exit
end

require 'fileutils'

#ディレクトリ生成
#/assessment直下に年度ディレクトリを生成

dir_path = "../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/ssl"
FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)

dir_path = "../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/result"
FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)








system("ruby index.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby global.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby purpose.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby manual.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby process.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby subjects.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby enq.rb #{ARGV[0]} #{ARGV[1]}")
#result内のphpファイル生成
system("ruby output.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby evaluation.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby index_out.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby makepage.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby result_menu_ber.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby result_top.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby teacher_result.rb #{ARGV[0]} #{ARGV[1]}")
#ssl内のphpファイル生成
system("ruby addclass.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby addclass_k.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby form.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby edit.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby indexphp.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby in_class.rb #{ARGV[0]} #{ARGV[1]}")
system("ruby logout.rb #{ARGV[0]} #{ARGV[1]}")
system("chmod 755 ../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/result/evaluation.php")
puts("エラーがでなければ生成完了")

exit
