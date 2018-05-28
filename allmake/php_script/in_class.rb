# -*- coding: utf-8 -*-

# 第1引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[0] == "a" then
  period="前期"
elsif ARGV[0] == "b" then
  period="後期"
end

w = open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/ssl/in_class.php","w")
w.print("
<?php
	/* セッションを作成 */
	session_start();
?>

<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"../r.css\">
<title>調査解析班#{period}授業評価アンケート</title>
<script type=\"text/javascript\" src=\"r3.js\">
<!--
-->
</script>
</head>

<body onLoad=\"setTimeout('goindex()',2000)\">

<div id=\"container\">
<div id=\"main\">

<?php
include(\"../global.php\");
title();

/* ログイン済みか確認 */
check_login();

/* PostgreSQL サーバに接続 */
$con = m_connect();

$sql_userid = getenv(\"REMOTE_USER\");
/*科目（新規書き込みなのか編集なのか）のチェック*/
$query = \"select * from addclass where id ='$sql_userid';\";
$rs = m_query($con,$query,\"データの検索に失敗しました。\");

//pg_free_result($rs);
$maxrows = pg_num_rows($rs);
$query = \"select table_name from classname;\";
$rs2 = m_query($con,$query,\"検索に失敗しました。\");
$max = pg_num_rows($rs2);
for($i=0; $i<$max; $i++){
  $class_data[$i] = pg_fetch_row($rs2, $i, PGSQL_ASSOC);
}

/* 登録データの構築 */
/*新規書き込み*/
if($maxrows == 0 ){
  $data[] = escape_string($sql_userid);
  $data[] = escape_string($_POST['grade']);
  foreach($class_data as $key){
    $data[] = escape_string ($_POST[$key['table_name']]);
  }

  $data = implode(\", \", $data);
  $query = \"insert into addclass(
        id,
        grade\";
  foreach($class_data as $key){
    $query = $query.\", \".$key['table_name'];
  }

  $query = $query.\") values ($data);\";
 }
/*編集*/
 else{
   $id =	escape_string ($sql_userid);
   $grade = escape_string ($_POST['grade']);
   $query = \"update addclass set grade = $grade\";

   foreach($class_data as $key){
     $all = escape_string ($_POST[$key['table_name']]);
     $query = $query.\", \".$key['table_name'].\" = \".$all;
   }
   $query = $query.\" where id = '$sql_userid';\";
 }

/* 登録を実行 */
$rtn = m_query($con, $query, \"科目の追加に失敗しました。\");

/* 科目の削除を行った際に、その科目のレコードを削除する。 */
$query = \"select * from addclass where id ='$sql_userid';\";
$rs = m_query($con,$query,\"データの検索に失敗しました。\");
$user_data = pg_fetch_array($rs);
foreach($class_data as $key){
  if ($user_data[$key['table_name']] == NULL) {
    $query = \"delete from $key[table_name] where id = '$sql_userid';\";
    $rs = m_query($con,$query,\"データの削除に失敗しました。\");
  }
}

/* 科目の登録数が0の時、addclassからユーザーデータを削除する。*/
$query = \"select * from addclass where id ='$sql_userid';\";
$rs = m_query($con,$query,\"データの検索に失敗しました。\");
$user_data = pg_fetch_array($rs);
$judge = 0;
foreach($class_data as $key) {
  $judge += $user_data[$key['table_name']];
}
if ($judge == 0) {
  $query = \"delete from addclass where id = '$sql_userid';\";
  $rs = m_query($con,$query,\"データの検索に失敗しました。\");
 }



echo \"<center>\";

switch (pg_affected_rows($rtn)) {
 case 1:
   echo(\"<p class=\\\"caution\\\">科目の設定をしました。</p>\\n\");
   break;
 default:
   die_exit(\"追加できませんでした。\");
 }

/* 切断 */
m_close($con);

echo \"<p class=\\\"caution\\\">アンケートトップページに移動します。</p>\";
echo \"</center>\";

echo \"<br><font size=4><a
href=index.php\";
echo \">トップに戻る</a></font></p>\";

back2(1);

?>

</div>
</div>

</body>
</html>
")
w.close
