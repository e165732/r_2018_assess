# -*- coding: utf-8 -*-

# 第1引数に年度、第2引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[1] == "a" then
  period="前期"
elsif ARGV[1] == "b" then
  period="後期"
end
w = open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/result/result_menu_ber.php","w")
w.print("
<html>
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"./r3_2005.css\">
<?php 
include(\"../global.php\");
?>
<title>result_link_ber</title>
</head>
<body>
<center>
<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"
	bgcolor=\"#fff0e0\">
	<tr>
		<td><br>
		<table width=\"90%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"
			bgcolor=\"#ffffc0\" align=\"center\">
			<tr>
				<td align=\"center\"><b>授業評価アンケート<br>
				#{ARGV[0]}年度#{period}開講<br>
				講義一覧</b></td>
			</tr>
		</table>
		<br>
		</td>
	</tr>
</table>
</center>
<br>
<center><font size=\"2\"><a href=\"./result_top.php\"
	target=\"frame2\">トップページ</a></font></center>
<br>
<hr>
<center><font size=\"2\"> <a href=\"./output.php\"
	target=\"_blank\">授業評価アンケート回答状況</a> <br>
<br>
<a href=\"./teacher_result.php\" target=\"frame2\">授業に対するコメントと回答一覧</a> </font></center>
<hr>
<?php
$con = m_connect();
$sql = \"select * from classname;\";
$rs = m_query($con, $sql, \"検索に失敗しました。\");
$maxrows = pg_num_rows($rs);
for($i=0; $i < $maxrows; $i++){
  $class_data[$i] = pg_fetch_row($rs,$i,PGSQL_ASSOC);
 }

for($i=1; $i<=6; $i++){
  echo \"<center><div id=\\\"intro\\\">\\n\";
  if($i<5){
  	echo \"<b>【\".$i.\"年次】</b>\\n\";
  }else{
  	echo \"<b>【大学院 \".($i-4).\"年次】</b>\\n\";
  }
  echo \"</div></center>\\n\";
  echo \"<h4>＜座学系＞</h4>\\n\";
  echo '<ul class=\"menuber\">';
  foreach($class_data as $key){
    if($key['grade'] == $i && $key['prac'] == 0){
      echo \"<li><a href = \\\"./makepage.php?kamoku=\".$key['table_name'].\"\\\" target=\\\"frame2\\\">\".$key['class_name'].\"</a></li>\\n\";
    }
  }
  echo \"</ul>\";
  
  echo \"<h4>＜実験・実習系＞</h4>\\n\";
  echo '<ul class=\"menuber\">';
  foreach($class_data as $key){
    if($key['grade'] == $i && $key['prac'] == 1){
      echo \"<li><a href = \\\"./makepage.php?kamoku=\".$key['table_name'].\"&ex=1\\\" target=\\\"frame2\\\">\".$key['class_name'].\"</a></li>\\n\";
    }
  }
  echo \"</ul>\";

  if($i == 4){
    echo \"<h4>＜セミナー&卒業研究＞</h4>\\n\";
    echo '<ul class=\"menuber\">';
    foreach($class_data as $key){
      if($key['grade'] == $i && $key['prac'] == 2){
	echo \"<li><a href = \\\"./makepage.php?kamoku=\".$key['table_name'].\"&ex=2\\\" target=\\\"frame2\\\">\".$key['class_name'].\"</a></li>\\n\";
      }
    }
  }
  echo \"</ul>\";
  
  echo \"<!--\\n\";
  foreach($class_data as $key){
    if($key['grade'] == $i && $key['prac'] == 1){
	echo \"<li> <a href = \\\"./class/\".$key['table_name'].\".html\\\" target=\\\"frame2\\\">\".$key['class_name'].\"</a>\\n\";
    }
  }
  echo \"-->\\n\";
  echo  \"\\n<br><br>\\n\";
 }
?>
</body>
</html>
")
w.close
