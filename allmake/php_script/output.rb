# coding: utf-8
# require 'fileutils'

# 第1引数に年度、第2引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[1] == "a" then
  period="前期"
elsif ARGV[1] == "b" then
  period="後期"
end

File.open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/result/output.php","w") do |file|
  file.print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"
 \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"../r.css\">
<title>#{ARGV[0]}年度#{period}授業評価アンケート-現在の回答状況</title>
</head>
<body>
<div id=\"container\">
<div id=\"main\">

<?php
include(\"../global.php\");
title();
?>

<center>
<table border=\"3\">
<tr>
<td id=\"menu\">
<a href=\"../index.html\">トップページ</a>
</td>
<td id=\"menu\">
<a href=\"../purpose.php\">実施目的・注意事項</a>
</td>
<td id=\"menu\">
<a href=\"../subjects.php\">対象科目</a>
</td>
<td id=\"menu\">
<a href=\"../process.php\">回答の手順</a>
</td>
<td id=\"menu\">
<a href=\"../enq.php\">設問一覧</a>
</td>
<td id=\"menu\">
<a href=\"./output.php\">現在の回答状況</a>
</td>
</tr>
</table>
</center>

<h2 class=paragraph>ログインして科目を登録した人の数</h2>
<?php
  $con = m_connect();
  $sql_userid = escape_string($HTTP_SESSION_VARS[\"s_userid\"]);
  $name = $HTTP_SESSION_VARS[\"s_userid\"];
echo \"<table border=1 cellspacing=0 cellpadding=0>\";
//ログインした人の数を表示する。大学だと\"i\"の上限は\"4\"。大学院だと\"i\"の上限は\"2\"。
$All=0;
echo \"<tr><td id=\\\"mune\\\" width=\\\"50\\\" rowspan=\\\"4\\\" align=center>学部生</td>\";
for($i=1; $i<=4; $i++){
  $query=\"select id from addclass where grade=$i\";
  $rs=m_query($con,$query,\"人数検索に失敗しました。\");
  $check_row=pg_num_rows($rs);
  $All=$All+$check_row;
  echo\"<td id=\\\"menu\\\" width=\\\"50\\\" align=center>\".$i.\"年次</td><td id=\\\"menu\\\" width=\\\"50\\\" align=center>\";
  echo\"$check_row\";
  echo\"人</td></tr>\";
}
echo \"<tr><td id=\\\"mune\\\" width=\\\"50\\\" rowspan=\\\"2\\\" align=center>学院生</td>\";
for($i=5; $i<=6; $i++){
  $query=\"select id from addclass where grade=$i\";
  $rs=m_query($con,$query,\"人数検索に失敗しました。\");
  $check_row=pg_num_rows($rs);
  $All=$All+$check_row;
  $num = $i - 4;
  echo\"<td id=\\\"menu\\\" width=\\\"50\\\" align=center>\".$num.\"年次</td><td id=\\\"menu\\\" width=\\\"50\\\" align=center>\";
  echo\"$check_row\";
  echo\"人</td></tr>\";
 }

echo \"<tr><td id=\\\"menu\\\" width=\\\"100\\\" colspan=\\\"2\\\" align=center>合計</td><td id=\\\"menu\\\" width=\\\"50\\\" align=center>\";
  echo \"$All\";
  echo \"人</td></tr>\";
  echo \"</table>\";

  echo \"<h2 class=paragraph>科目毎の受講人数、回答数と未回答数</h2>\";
  echo \"<p>「科目名(教員名)」をクリックすると、詳細な回答状況を見ることができます</p>\";

$sql=\"select * from classname;\";
$rs=m_query($con,$sql,\"検索に失敗しました\");
$maxrows=pg_num_rows($rs);
$All_ave=0;

echo \"<h3 class=\\\"list\\\">1年次対象科目</h3>\";
echo \"<table border=1 cellspacing=0 cellpadding=10>\";
echo \"<tr><th width=\\\"414\\\">科目名</th><th>登録数</th><th>回答数</th><th>回答率</th><th>未回答数</th></tr>\";

for ($i=0; $i<$maxrows; $i++) {
  $arr=pg_fetch_array($rs, $i, PGSQL_ASSOC);
  if (preg_match(\"/1/\", $arr['grade'])) {
    echo \"<tr><td>\";
    if ($arr[prac] == 0) {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    } else {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"&ex=1\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    }
    echo \"</td><td align=center>\";
    echo \"$arr[touroku]\";
    echo \"</td>\";
    $sql=\"select id from $arr[table_name];\";
    $rs1=m_query($con,$sql,\"検索に失敗しました。\");
    $row_data=pg_num_rows($rs1);
    echo \"<td align=center>\";
    echo \"$row_data\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=blue>\";
    echo $ave=number_format(($row_data/$arr[touroku])*100,1);
    echo \"</font>％\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=red>\";
    echo ($arr[touroku]-$row_data);
    echo \"</font>\";
    echo \"</td></tr>\";
    $All_ave=$All_ave+$ave;
  }
 }
echo \"</table>\";

echo \"<h3 class=\\\"list\\\">2年次対象科目</h3>\";
echo \"<table border=1 cellspacing=0 cellpadding=10>\";
echo \"<tr><th width=\\\"414\\\">科目名</th><th>登録数</th><th>回答数</th><th>回答率</th><th>未回答数</th></tr>\";
for ($i=0; $i<$maxrows; $i++) {
  $arr=pg_fetch_array($rs, $i, PGSQL_ASSOC);
  if (preg_match(\"/2/\", $arr['grade'])) {
    echo \"<tr><td>\";
    if ($arr[prac] == 0) {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    } else {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"&ex=1\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    }
    echo \"</td><td align=center>\";
    echo \"$arr[touroku]\";
    echo \"</td>\";
    $sql=\"select id from $arr[table_name];\";
    $rs1=m_query($con,$sql,\"検索に失敗しました。\");
    $row_data=pg_num_rows($rs1);
    echo \"<td align=center>\";
    echo \"$row_data\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=blue>\";
    echo $ave=number_format(($row_data/$arr[touroku])*100,1);
    echo \"</font>％\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=red>\";
    echo ($arr[touroku]-$row_data);
    echo \"</font>\";
    echo \"</td></tr>\";
    $All_ave=$All_ave+$ave;
  }
 }
echo \"</table>\";

echo \"<h3 class=\\\"list\\\">3年次対象科目</h3>\";
echo \"<table border=1 cellspacing=0 cellpadding=10>\";
echo \"<tr><th width=\\\"414\\\">科目名</th><th>登録数</th><th>回答数</th><th>回答率</th><th>未回答数</th></tr>\";
for ($i=0; $i<$maxrows; $i++) {
  $arr=pg_fetch_array($rs, $i, PGSQL_ASSOC);
  if ($arr[grade] == 3) {
    echo \"<tr><td>\";
    if ($arr[prac] == 0) {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    } else {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"&ex=1\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    }
    echo \"</td><td align=center>\";
    echo \"$arr[touroku]\";
    echo \"</td>\";
    $sql=\"select id from $arr[table_name];\";
    $rs1=m_query($con,$sql,\"検索に失敗しました。\");
    $row_data=pg_num_rows($rs1);
    echo \"<td align=center>\";
    echo \"$row_data\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=blue>\";
    echo $ave=number_format(($row_data/$arr[touroku])*100,1);
    echo \"</font>％\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=red>\";
    echo ($arr[touroku]-$row_data);
    echo \"</font>\";
    echo \"</td></tr>\";
    $All_ave=$All_ave+$ave;
  }
 }
echo \"</table>\";

echo \"<h3 class=\\\"list\\\">4年次対象科目</h3>\";
echo \"<table border=1 cellspacing=0 cellpadding=10>\";
echo \"<tr><th width=\\\"414\\\">科目名</th><th>登録数</th><th>回答数</th><th>回答率</th><th>未回答数</th></tr>\";
for ($i=0; $i<$maxrows; $i++) {
  $arr=pg_fetch_array($rs, $i, PGSQL_ASSOC);
  if ($arr[grade] == 4) {
    echo \"<tr><td>\";
    if ($arr[prac] == 0) {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    } elseif ($arr[prac] == 1) {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"&ex=1\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    } else {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"&ex=2\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    }
    echo \"</td><td align=center>\";
    echo \"$arr[touroku]\";
    echo \"</td>\";
    $sql=\"select id from $arr[table_name];\";
    $rs1=m_query($con,$sql,\"検索に失敗しました。\");
    $row_data=pg_num_rows($rs1);
    echo \"<td align=center>\";
    echo \"$row_data\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=blue>\";
    echo $ave=number_format(($row_data/$arr[touroku])*100,1);
    echo \"</font>％\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=red>\";
    echo ($arr[touroku]-$row_data);
    echo \"</font>\";
    echo \"</td></tr>\";
    $All_ave=$All_ave+$ave;
  }
 }
echo \"</table>\";

echo \"<h3 class=\\\"list\\\">院生対象科目</h3>\";
echo \"<table border=1 cellspacing=0 cellpadding=10>\";
echo \"<tr><th width=\\\"414\\\">科目名</th><th>登録数</th><th>回答数</th><th>回答率</th><th>未回答数</th></tr>\";
for ($i=0; $i<$maxrows; $i++) {
  $arr=pg_fetch_array($rs, $i, PGSQL_ASSOC);
  if ($arr[grade] == 5) {
    echo \"<tr><td>\";
    if ($arr[prac] == 0) {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    } else {
      echo \"<a href = \\\"./evaluation.php?kamoku=\".$arr[table_name].\"&ex=1\\\">\".$arr[class_name].\"(\".$arr[kyouin].\")</a>\";
    }
    echo \"</td><td align=center>\";
    echo \"$arr[touroku]\";
    echo \"</td>\";
    $sql=\"select id from $arr[table_name];\";
    $rs1=m_query($con,$sql,\"検索に失敗しました。\");
    $row_data=pg_num_rows($rs1);
    echo \"<td align=center>\";
    echo \"$row_data\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=blue>\";
    echo $ave=number_format(($row_data/$arr[touroku])*100,1);
    echo \"</font>％\";
    echo \"</td>\";
    echo \"<td align=center>\";
    echo \"<font color=red>\";
    echo ($arr[touroku]-$row_data);
    echo \"</font>\";
    echo \"</td></tr>\";
    $All_ave=$All_ave+$ave;
  }
 }
echo \"</table>\";

echo \"<BR><h1>平均回答率\";
echo number_format(($All_ave/$maxrows),1);
echo \"％</h1>\";
  back2();
?>

</body>
</html>")
end
