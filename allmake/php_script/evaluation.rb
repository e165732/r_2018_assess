# coding: utf-8
require 'fileutils'

# 第1引数に年度、第2引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[0] == "a" then
  period="前期"
elsif ARGV[0] == "b" then
  period="後期"
end

File.open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/result/evaluation.php","w") do |file|
  file.print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"
 \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">

<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"../r.css\">


<?php
include(\"../global.php\");
$kamoku = $_GET['kamoku'];
$ex = $_GET['ex'];

/* PostgreSQL サーバに接続 */
$con = m_connect();
$query1 = \"select * from classname where table_name='$kamoku';\";
$rs1 = m_query($con, $query1, \"検索に失敗しました。\");
$rowdata = pg_fetch_array($rs1,0,PGSQL_ASSOC);
echo \"<title>#{ARGV[0]}年度#{period}授業評価アンケート-\".$rowdata['class_name'].\"</title>\\n\";
?>
</head>
<body>

<?php
/* セッションを作成 */
session_start();
/* 画像ファイルがおいてあるディレクトリを指定してください。 */
$graph_dir = 'plot';

// PostgreSQL サーバに接続
$con = m_connect();

// セッションに保存
//	session_register(\"s_kamoku\");
$_SESSION[\"s_kamoku\"] = $kamoku;
$_SESSION[\"s_ex\"] = $ex;

?>

<div id=\"container\">
<div id=\"main\">
<?php
/*回答状況のチェック*/
$query = \"select * from $kamoku ;\";
$rs = m_query($con, $query, \"検索に失敗しました。\");
$maxrows = pg_num_rows($rs);


if ($maxrows!=0){
	/* 検索結果を取得 */
	if (!($rowdata = pg_fetch_all($rs))) {
		die_exit(\"データは存在しません\");
	}
}

// 検索結果を解放
pg_free_result($rs);

?> <?php
title();
?>

<div align=\"center\">
<table id=\"margin\" border=\"3\">
	<tr>
		<td id=\"menu\"><a href=\"../index.html\">トップページ</a></td>
		<td id=\"menu\"><a href=\"../purpose.php\">実施目的・注意事項</a></td>
		<td id=\"menu\"><a href=\"../subjects.php\">対象科目</a></td>
		<td id=\"menu\"><a href=\"../process.php\">回答の手順</a></td>
		<td id=\"menu\"><a href=\"../enq.php\">アンケートの設問内容</a></td>
		<td id=\"menu\"><a href=\"./output.php\">現在の回答状況</a></td>
	</tr>
</table>
</div>

<?php

$query1 = \"select * from classname where table_name='$kamoku';\";
$rs1 = m_query($con, $query1, \"検索に失敗しました。\");
$query2 = \"select * from \".$kamoku.\";\";
$rs2 = m_query($con, $query2, \"失敗\");
$query3 = \"select * from enq_list;\";
$rs3 = m_query($con, $query3, \"検索に失敗しました。\");

$rowdata = pg_fetch_array($rs1,0,PGSQL_ASSOC);
echo '<h2 class=\"paragraph\">';
echo $rowdata['class_name'].\"の授業評価</h2>\\n\";
echo \"<center><font size=4><br>\";
$check_row = pg_num_rows($rs2);
echo $check_row.\"人/ \";
$rowdata = pg_fetch_array($rs1,0, PGSQL_ASSOC);
echo $rowdata['touroku'].\"人\";

echo \"<span class=\\\"response_rate\\\">(\".number_format(($check_row*100/$rowdata['touroku']),1).\"%)</span>\\n\";
echo \"【 回答者 / 登録者 / (回答率) 】\";
echo \"</font></center>\";

// 配列の定義
$color = array('red','yellow','lime','aquamarine','dodgerblue','purple','gray');

// 問題文の数
$max_enq = pg_num_rows($rs3);

for($i=0; $i<$max_enq; $i++) {
	$enq_data[$i] = pg_fetch_row($rs3, $i, PGSQL_ASSOC);
}

$repnum = 1;
$sub_enq=0;
for ($i=0; $i<($max_enq-1); $i++) {
	$enq_type = $enq_data[$i]['enq_type'];

	// 座学系の授業なら実験系の問題をスルーする
	#if($ex != 1 && $enq_data[$i]['enq_prac'] == \"1\")continue;
	if($ex != 2 && $enq_data[$i]['enq_prac'] == \"2\"){
          continue;
        }
        elseif($ex != 1 && $enq_data[$i]['enq_prac'] == \"1\"){
          continue;
        }
        elseif($ex == 2  && $enq_data[$i]['enq_prac'] != \"2\"){
          continue;
        }

	if($sub_enq > 0){
		echo \"<h5 class=\\\"question\\\">\".$enq_data[$i]['enq_str'].\"</h5>\\n\";
		echo \"<p class=\\\"topic-content\\\">\\n\";
		$sub_enq--;
	}else{
		$qnum = strtoupper($enq_data[$i]['enq_num']);
		echo \"<h4 class=\\\"question\\\">\".$qnum.\".\".$enq_data[$i]['enq_str'].\"</h4>\";
		echo \"<p class=\\\"topic-content\\\">\\n\";
	}

	switch ($enq_type) {
		case 'radio':
			// 回答文の数
			$query4 = \"select * from ans_list where ans_num = '\".$enq_data[$i]['enq_num'].\"'\";
			$rs4 = m_query($con, $query4, \"検索に失敗しました。\");
			$max_ans = pg_num_rows($rs4);
			for ($j=0; $j<$max_ans; $j++) {
				$ans_data[$j] = pg_fetch_row($rs4, $j, PGSQL_ASSOC);
			}
			$all = 0;
			// 回答ごとの人数をグラフで表示する
			for ($j=0; $j<$max_ans; $j++) {
				$query5 = \"select * from $kamoku where \".$enq_data[$i]['enq_num'].\"=\".($j+1).\";\";
				$rs5 = m_query($con, $query5, \"検索に失敗しました。\");
				$check_row = pg_num_rows($rs5);
				$all += $check_row;
				$temp = $check_row / $rowdata['touroku'] * 600;
				if ($temp != 0) {
					echo \"<img class=\\\"zero\\\" src=\\\"./image/\".$color[$j].\".png\\\" width=\\\"\".$temp.\"\\\" height=\\\"10\\\">\";
				}
			}
			$temp = 600 - $all / $rowdata['touroku'] * 600;
			if ($temp != 0) {
				echo \"<img class=\\\"zero\\\" src=\\\"./image/\".$color[6].\".png\\\" width=\\\"\".$temp.\"\\\" height=\\\"10\\\">\\n\";
			}
			echo \"<br>\\n\";
			// 回答ごとの人数と色を表示する
			for ($j=0; $j<$max_ans; $j++) {
				$query5 = \"select * from $kamoku where \".$enq_data[$i]['enq_num'].\"=\".($j+1).\";\";
				$rs5 = m_query($con, $query5, \"検索に失敗しました。\");
				$check_row = pg_num_rows($rs5);
				echo \"<font color=\\\"\".$color[$j].\"\\\">■</font>\".($j+1).\".\".$ans_data[$j]['ans_str'].\"　\".$check_row.\"人<br>\\n\";
			}
			echo \"</p>\\n\";
			break;

		case 'text':
			$qnum = $enq_data[$i]['enq_num'];
			$query6 = \"select $qnum from $kamoku where $qnum != '';\";
			$rs6 = m_query($con, $query6, \"検索に失敗しました。\");
			$arr = pg_fetch_all($rs6);
			$loop_num = 0;
			echo \"<ul>\";
			for ($loop_num=0;  $loop_num<count($arr);  ++$loop_num) {
				if ( $arr[$loop_num][$qnum] == '' ) { break; }
				echo \"<li>\".$arr[$loop_num][$qnum];
				echo \"</li>\\n\";
			}
			echo \"</ul>\\n\";
			$rep_a = \"a$repnum\";
			$query = \"select $rep_a from teacher where kamoku = '$kamoku' ;\";
			$rs7 = m_query($con, $query, \"検索に失敗しました。\");
			$reply = pg_fetch_row($rs7, 0, PGSQL_ASSOC);
			$repnum++;
			echo \"<pre><b>   要望に対する回答</b></pre>\\n\";
			echo \"<ul>\\n\";
			echo nl2br($reply[$rep_a]);
			echo \"</ul>\\n\";
			echo \"</p>\\n\";
			echo \"<br><br>\";
			break;

		default:
			if(is_numeric($enq_type)){
				$sub_enq = intval($enq_type);
			}
			echo \"</p>\\n\";
			break;
	}
}

// オリジナル問題
$query8 = \"select org_enq from original_q where class_id = '$kamoku' ;\";
$rs8 = m_query($con, $query8, \"検索に失敗しました。\");
$arr = pg_fetch_all($rs8);
if (nl2br($arr[0]['org_enq']) != NULL) {
	$org_qnum = $enq_data[$max_enq-1]['enq_num'];
	$qnum2 = strtoupper($org_qnum);
	echo \"<h3 class=\\\"caution\\\">\".$qnum2.\"は担当教員による独自設問となっています。</h3>\\n\";
	echo \"<h4 class=\\\"question\\\">\".$qnum2.\".\".$arr[0]['org_enq'];
	echo \"</h4>\\n\";
	$query9 = \"select $org_qnum from $kamoku where $org_qnum != '' ;\";
	$rs9 = m_query($con, $query9, \"検索に失敗しました。\");
	$arr = pg_fetch_all($rs9);
	echo \"<ul>\\n\";
	for ($loop_num=0;  $loop_num<count($arr);  ++$loop_num) {
		if ( $arr[$loop_num][$org_qnum] == '' ) { break; }
		echo \"<li>\".$arr[$loop_num][$org_qnum].\"</li>\\n\";
	}
	echo \"</ul>\\n\";
}
echo \"<br><br>\";
?> <?php
back2();
?></div>
</div>
</body>
</html>
")
end
