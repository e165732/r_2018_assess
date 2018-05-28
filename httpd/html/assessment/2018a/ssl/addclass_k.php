
<?php
/* セッションを作成 */
session_start();
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<link rel="stylesheet" type="text/css" href="../r.css">
<title>調査解析班授業評価アンケート</title>
<script type="text/javascript">
function gradecheck(){
	if(!document.input.grade[0].checked &&
	!document.input.grade[1].checked) {
		alert('学年が未選択です');
		return false;
	}
	return true;
}
</script>
</head>

<body>

<div id="container">
<div id="main"><?php
include ("../global.php");
title();
check_login();
$con = m_connect();
//データベースサーバに接続
$sql_userid = getenv("REMOTE_USER");
//ユーザ名を取得
$query = "select * from addclass where id = '$sql_userid';";
//ユーザがどの教科を受講したかのデータを取ってくるsql文
$rs = m_query($con, $query, "検索に失敗しました。");
//検索開始
$maxrows = pg_num_rows($rs);
if ($maxrows != 0){
    //その行数が"0"(何も受講していない)でなければ、以下を実行
    if (!($rowdata = pg_fetch_array($rs, 0, PGSQL_ASSOC))){
      //取得したレコードをそれぞれのフィールドで連想配列に格納する。
      die_exit("データは存在しません");
    }
  }
pg_free_result($rs);
//検索結果を解放
$sql = "select * from classname;";
$rs2 = m_query($con, $sql, "検索に失敗しました。");
$maxrows = pg_num_rows($rs2);
for($i=0; $i<$maxrows; $i++){
	  $class_data[$i] = pg_fetch_row($rs2,$i,PGSQL_ASSOC);
  }

?>
<form name="input" action="in_class.php" method="POST"
	onsubmit="return gradecheck();"
	onreset="return confirm('フォームを変更前の状態に戻しますか?');">

<h2 class="paragraph">学年</h2>
<div class="leftspace">
<h4>あなたは現在何年次ですか？</h4>
<p><label for="m1"><input class="leftspace" type="radio" name="grade" id="m1" value="5"
	<?php if(($rowdata['grade']) == '5' ) echo(" checked"); ?>>1年次</label>
<label for="m2"><input class="leftspace" type="radio" name="grade" id="m2" value="6"
	<?php if(($rowdata['grade']) == '6' ) echo(" checked"); ?>>2年次</label>
</p>
</div>

<h2 class="paragraph">受講科目の選択</h2>

<h3 class="leftspace"><?php print(getenv(REMOTE_USER)); ?>さんが現在受講登録している講義にチェックをつけて科目を追加してください。</h3>

<h3 class="list">院生対象科目</h3>
<table border="1" cellspacing="0" cellpadding="5"
	class="kamoku leftspace">
	<tr>
		<th width="150">座学系</th>
		<td><?php
  foreach($class_data as $key ){
  if($key['grade'] == "5" && $key['prac'] == 0){
    echo '<label for="'.$key['table_name'].'"><input type="checkbox" name="'.$key['table_name'].'" id="'.$key['table_name'].'" value="1"';
    if(($rowdata[$key['table_name']]) == '1' ){
      print(" checked ");
    }
    print(">".$key['class_name']."</label><br>\n");
  }
}
?>
		</td>
	</tr>
	<tr>
		<th width="150">実習・実験系</th>
		<td><?php
  foreach($class_data as $key ){
  if($key['grade'] == "5" && $key['prac'] == 1){
    echo '<label for="'.$key['table_name'].'"><input type="checkbox" name="'.$key['table_name'].'" id="'.$key['table_name'].'" value="1"';
    if(($rowdata[$key['table_name']]) == '1' ){
      print(" checked ");
    }
    print(">".$key['class_name']."</label><br>\n");
  }
}
?>
		</td>
	</tr>
</table>


<p><input type="submit" class="leftspace" value="追加・削除"> <input
	type="RESET" class="leftspace" value="変更前の状態に戻す"></p>
<p class="error">ボタンが反応しないときは画面をリロードして再回答してください。</p>

</form>

<?php
back2(1);
?></div>
</div>

</body>
</html>
