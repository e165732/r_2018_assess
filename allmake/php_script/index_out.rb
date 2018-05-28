# -*- coding: utf-8 -*-


File.open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/result/index_out.html","w") do |file|
 file.print("
<html>
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\" />
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\" />
<link rel=\"stylesheet\" type=\"text/css\" href=\"./r3_2005.css\" />
<title>授業評価アンケート結果ページ</title>
</head>
<frameset border=1 bordercolor=\"red\" cols=\"200,*\">
	<frame src=\"./result_menu_ber.php\" name=\"frame1\">
	<frame src=\"./result_top.php\" name=\"frame2\">
</frameset>
</html>


")
end
