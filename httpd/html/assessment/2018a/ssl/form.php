
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

</head>

<body>

<div id="container">
<div id="main"><?php
include("../global.php");
title();
$sql_userid = getenv("REMOTE_USER");
$kamoku = $_GET['kamoku'];
$ex = $_GET['ex'];

// ログイン済みか確認
check_login();
// PostgreSQL サーバに接続
$con = m_connect();

// セッションに科目名と座学か実習・実験系かどうか判断する値を保存
$_SESSION['s_kamoku']=$kamoku;
$_SESSION['s_ex']=$ex;

$query = "select * from classname where table_name='$kamoku';";
$rs = m_query($con, $query, "検索に失敗しました。");
$rowdata = pg_fetch_array($rs, 0, PGSQL_ASSOC);
echo "<h2 class=\"paragraph\">";
print ($rowdata['class_name']);
echo "の授業評価</h2>";

$query = "select * from $kamoku where id = '$sql_userid';";
$rs = m_query($con, $query, "検索に失敗しました。");
$maxrows = pg_num_rows($rs);
if ($maxrows!=0){
	/* 検索結果を取得 */
	if (!($rowdata = pg_fetch_array($rs, 0, PGSQL_ASSOC))) {
		die_exit("データは存在しません");
	}
}
// 検索結果を解放
pg_free_result($rs);
?>

<p>それぞれ設問について、適当な項目を選択するか、記入をしてください。</p>
<p>※記入式設問では、<font color="red">日本語または英語</font>でお答え下さい。</p>

<?php
echo '<form name="input" action="edit.php" method="POST" onsubmit="return checkInput()" onreset="return confirm(\'フォームの内容をリセットしますか?\');"> '."\n";

$sql = "select * from enq_list;";
$rs = m_query($con, $sql, "検索に失敗しました。");
$max_enq = pg_num_rows($rs);
for($i=0; $i<$max_enq; $i++) {
	$enq_data[$i] = pg_fetch_row($rs, $i, PGSQL_ASSOC);
}

$sub_enq=0;
for ($i=0; $i<($max_enq-1); $i++) {
	$enq_type = $enq_data[$i]['enq_type'];

        if($ex != 2 && $enq_data[$i]['enq_prac'] == "2"){
          continue;
        }
        elseif($ex != 1 && $enq_data[$i]['enq_prac'] == "1"){
          continue;
        }
        elseif($ex == 2  && $enq_data[$i]['enq_prac'] != "2"){
          continue;
    	}
	if($sub_enq > 0){
		echo "<div class=\"leftspace\"> \n";
		echo "<h5 class=\"question\">".$enq_data[$i]['enq_str']."</h5>\n";
		echo "<textarea name=\"".$enq_data[$i]['enq_num']."\" ";
		echo "rows=\"5\" cols=\"60\">".$rowdata[$enq_data[$i]['enq_num']]."</textarea><br> \n";
		echo "</div>";
		$sub_enq--;
		continue;
	}
	$qnum = strtoupper($enq_data[$i]['enq_num']);
	echo "<h4 class=\"question\">".$qnum.".".$enq_data[$i]['enq_str']."</h4>";
	echo "<div class=\"leftspace\"> \n";
	switch ($enq_type) {
		case 'radio':
			$sql = "select * from ans_list where ans_num = '".$enq_data[$i]['enq_num']."'";
			$rs = m_query($con, $sql, "検索に失敗しました。");
			$max_ans = pg_num_rows($rs);
			for ($j=0; $j<$max_ans; $j++) {
				$ans_data[$j] = pg_fetch_row($rs, $j, PGSQL_ASSOC);
				echo ($j+1).".";
				echo '<label for="'.$i.$j.'">';
				echo '<input type="radio"';
				echo 'name="'.$enq_data[$i]['enq_num'].'" ';
				echo 'value="'.($j+1).'" ';
				if ($rowdata[$enq_data[$i]['enq_num']] == ($j+1)) {
					echo(" checked ");
				}
				if ($j >= 1) echo " tabindex=-1 ";
				echo ' id = "'.$i.$j.'"';
				echo ">".$ans_data[$j]['ans_str']."</label><br> \n ";
			}
			echo "</div>\n";
			break;

		case 'text':
			echo '<textarea name="'.$enq_data[$i]['enq_num']. '" ';
			echo 'rows="5" cols="60">'.$rowdata[$enq_data[$i]['enq_num']]."</textarea><br>";
			echo "</div>\n";
			break;

		default:
			if(is_numeric($enq_type)){
				$sub_enq = intval($enq_type);
			}
			echo "</div>\n";
			break;
	}

}

$query = "select org_enq from original_q where class_id = '$kamoku' ;";
$rs = m_query($con, $query, "検索に失敗しました。");
$arr = pg_fetch_all($rs);
if (nl2br($arr[0][org_enq]) !=NULL) {
	$qnum = strtoupper($enq_data[$max_enq-1]['enq_num']);
	echo "<h3 class=\"caution\">{$qnum}は担当教員による独自設問となっています。</h3>";
	echo "<h4 class=\"question\">{$qnum}.";
	echo nl2br($arr[0][org_enq]);
	echo "</h4>";
	echo "<div class=\"leftspace\">";
	echo "<textarea name=\"{$enq_data[$max_enq-1]['enq_num']}\" rows=\"5\" cols=\"60\">";
	echo $rowdata[$enq_data[$max_enq-1]['enq_num']];
	echo "</textarea>";
	echo "</div>";
}

?>
<!-- ボタン -->
<p><input class="leftspace" type="submit" value="送信"> <input
	class="leftspace" type="reset" value="リセット"></p>

<?php
back2(1);
echo '</form>'
?></div>
</div>
<!--回答必須の設問に回答しているかのチェック-->
<script type="text/javascript">
function checkInput(){
	var check_flag = true;
	var err_str = new Array();
	var inp;
	var qflag = new Array();
	<?php
	$sqljs = "select * from enq_list;";
	$rsjs = m_query($con, $sqljs, "検索に失敗しました。");
	$max_enq = pg_num_rows($rsjs);
	for($i=0; $i<$max_enq; $i++) {
		$enq_data[$i] = pg_fetch_row($rsjs, $i, PGSQL_ASSOC);
		$hissu[$i] = $enq_data[$i]['enq_hissu'];
		$prac[$i] = $enq_data[$i]['enq_prac'];
	}
	for ($i=0; $i<$max_enq; $i++) {
		if($hissu[$i] != '1') continue;

		if($ex != 2 && $prac[$i] == "2"){
		  continue;
		}
		elseif($ex != 1 && $prac[$i] == "1"){
		  continue;
		}
		elseif($ex == 2  && $prac[$i] != "2"){
		  continue;
		}

		#if($ex != 1 && $prac[$i] =='1') continue;
		$qnum = $enq_data[$i]['enq_num'];
		echo "var inp = document.input.".$qnum.";\n";
		echo "for(i=0;i<inp.length;i++){\n";
		echo "	if(inp[i].checked){\n";
		echo "		qflag[$i] = true;\n";
      	echo "	}\n";
		echo "}\n";
		echo "if(!qflag[$i]){\n";
		echo "	check_flag = false;\n";
		echo "	err_str = err_str + \" $qnum \";\n";
		echo "}\n";
		echo "\n";
	}
	?>

	err_str = err_str.toUpperCase()
	if(!check_flag){
		alert(err_str + "\nが未入力です");
		return false;
	}
	return true;
}
</script>

</body>
</html>
