# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
#ipアドレス取得
#require 'net/http'
#ip=Net::HTTP.get('ifconfig.me','/ip').strip!
require 'socket'
#ipアドではなくサーバーネームをとるようにした7/10
#サーバーネーム取得
ip=Socket.gethostname

# 第1引数に年度、第2引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[1] == "a" then
  period="前期"
elsif ARGV[1] == "b" then
  period="後期"
end

#カレントディレクトリを取得
#dir=Dir::pwd
#dirary=dir.split("/")
#i=0
#while i < dirary.length
# if dirary[i] == "html"
#  i+=1
#  dirnum=i
# end
# i+=1
#end
#homedir=dirary[dirnum]
#dirnum+=1
#while dirnum < dirary.length-1
#  homedir << "/#{dirary[dirnum]}"
# dirnum+=1
#end


w = open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/index.html","w")
w.puts( "  <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN \" \"http://www.w3.org/TR/html4/strict.dtd \">    ")
w.puts("<html lang=\"ja\">")
w.puts("<head>")
w.puts("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">")
w.puts("<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">")
w.puts("<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">")
w.puts("<link rel=\"stylesheet\" type=\"text/css\" href=\"./r.css\">")
w.puts("<script type='text/javascript' src='./jquery-1.11.1.min.js'></script>")
w.puts("<script type='text/javascript'>")
w.puts("function slideSwitch() {")
w.puts("var $active = $('#slideshow img.active');")
w.puts("if ( $active.length == 0 ) $active = $('#slideshow img:last');")
w.puts("var $next = $active.next().length ? $active.next() : $('#slideshow img:first');")
w.puts("$active.addClass('last-active');")
w.puts("$next.css({opacity: 0.0}).addClass('active').animate({opacity: 1.0}, 1000, function() { $active.removeClass('active last-active'); });  ")
w.puts("}")
w.puts("$(function() { setInterval( 'slideSwitch()', 3000 ); });")
w.puts("</script>")
w.puts("   <title>#{ARGV[0]}年度#{period}授業評価アンケート-トップページ</title> ")
w.puts("</head>")
w.puts("")
w.puts("<body>")
w.puts("<div id=\"container\">")
w.puts("<div id=\"main\">")
w.puts(" <h1 class=title>#{ARGV[0]}年度#{period}授業評価アンケート</h1>")
w.puts("<center>")
w.puts("<table id=\"margin\" border=\"3\">")
w.puts("<tr>")
w.puts("  <td id=\"menu\"><a href=\"./index.html\">トップページ</a></td>")
w.puts("<td id=\"menu\"><a href=\"./purpose.php\">実施目的・注意事項</a></td>")
w.puts("<td id=\"menu\"><a href=\"./subjects.php\">対象科目</a></td>")
w.puts("<td id=\"menu\"><a href=\"./process.php\">回答の手順</a></td>")
w.puts("<td id=\"menu\"><a href=\"./enq.php\">設問一覧</a></td>")
w.puts("<td id=\"menu\"><a href=\"./result/output.php\">現在の回答状況</a></td>")
w.puts("</tr>")
w.puts("</table>")
w.puts("")
w.puts("<p></p>")
w.puts("")
w.puts("<!--<font size=\"6\" color=\"red\">〜授業評価アンケート新時代へ突入〜<br>  ")
w.puts(" <a href=\"./manual.php\"><font color=red>[アンケート開始の前に必ずお読み下さい]</font></a></font>-->")
w.puts("<a href=\"./manual.php\"><font size=\"6\" color=red>[アンケート開始の前に必ずお読み下さい]</font></a>")
w.puts("<br>")
w.puts(" <font size=\"10\"><a href=\"https://#{ip}/assessment/#{ARGV[0]}#{ARGV[1]}/ssl/index.php\" target=\"question\" onclick=\"window.open(this.href, 'quiestion', 'width=820, menubar=no, toolbar=no, scrollbars=yes'); return false;\">[ アンケート開始 ]</a></font><br>")
#w.puts(" <font size=\"10\"><a href=\"https://#{ip}/#{homedir}/ssl/index.php\" target=\"question\" onclick=\"window.open(this.href, 'quiestion', 'width=820, menubar=no, toolbar=no, scrollbars=yes'); return false;\">[ アンケート開始 ]</a></font><br>")
w.puts("")
w.puts("")
w.puts(" <!-- <font size=\"10\"><del>[アンケート開始]</del></font> -->")
w.puts("<br>")
w.puts("<!-- <p>2014年#{period}のアンケートは終了しました。ご協力ありがとうございました。</p> -->")
w.puts("<p id='slideshow'>")
#w.puts("<img src='./img/top2010b.jpg' width='540' height='401'
#               alt="" class='active'></img>")
w.puts("<img src='./img/a0.jpg' width='540' height='401' alt='' class='active' ></img>")
w.puts("<img src='./img/a1.jpg' width='540' height='401' alt='' ></img>")
w.puts("<img src='./img/a2.jpg' width='540' height='401' alt='' ></img>")
w.puts("<img src='./img/a3.jpg' width='540' height='401' alt='' ></img>")
w.puts("<img src='./img/a4.jpg' width='540' height='401' alt='' ></img>")
w.puts("<img src='./img/a5.jpg' width='540' height='401' alt='' ></img>")
w.puts("<img src='./img/a6.jpg' width='540' height='401' alt='' ></img>")
w.puts("<p>")
w.puts("")
w.puts("</center>")
w.puts("")
w.puts(" <hr>")
w.puts("<a href=\"http://#{ip}/assessment/\">R班トップページ</a>")
w.puts("<br>")
w.puts("<p class=\"copyright\">#{ARGV[0]}年度情報工学実験3 調査と解析(R)班")
w.puts("<br>")
w.puts("<a href=\"mailto:r-inquiry@ms.ie.u-ryukyu.ac.jp?subject=#{ARGV[0]}年度#{period}授業評価アンケートについて\">r-inquiry@ms.ie.u-ryukyu.ac.jp</a>")
w.puts("</p>")
w.puts("</div>")
w.puts("</div>")
w.puts("</body>")
w.puts("")
w.puts("</html>")


w.close
